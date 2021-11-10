#include "GifWriter.h"

GifWriter::GifWriter(
        const std::filesystem::path& path,
        unsigned int width,
        unsigned int height,
        unsigned delay
) : file{path, std::ofstream::binary | std::ofstream::out} {
    file << "GIF89a";

    // screen descriptor
    file.put(width & 0xff);
    file.put((width >> 8) & 0xff);
    file.put(height & 0xff);
    file.put((height >> 8) & 0xff);

    file.put(0xf0);  // there is an unsorted global color table of 2 entries
    file.put(0);     // background color
    file.put(0);     // pixels are square (we need to specify this because it's 1989)

    // now the "global" palette (really just a dummy palette)
    // color 0: black
    file.put(0);
    file.put(0);
    file.put(0);
    // color 1: also black
    file.put(0);
    file.put(0);
    file.put(0);

    if (delay != 0) {
        // animation header
        file.put(0x21); // extension
        file.put(0xff); // application specific
        file.put(11); // length 11
        file << "NETSCAPE2.0"; // yes, really
        file.put(3); // 3 bytes of NETSCAPE2.0 data

        file.put(1); // JUST BECAUSE
        file.put(0); // loop infinitely (byte 0)
        file.put(0); // loop infinitely (byte 1)

        file.put(0); // block terminator
    }
}

GifWriter::~GifWriter() {
    file.close();
}

void GifWriter::writeFrame(const std::vector<uint8_t>& image,
                           unsigned width,
                           unsigned height,
                           unsigned delay,
                           unsigned bitDepth) {
    auto pal = makePalette(image, width, height, bitDepth);

    auto frame = thresholdImage(image, width, height, pal);

    writeLzwImage(frame, 0, 0, width, height, delay, pal);
}

GifPalette GifWriter::makePalette(
        const std::vector<uint8_t> &frame,
        unsigned width,
        unsigned height,
        unsigned bitDepth
) {
    GifPalette pPal{};
    pPal.bitDepth = bitDepth;

    std::vector<uint8_t> destroyableImage{frame};

    int numPixels = (int) (width * height);
    if (!this->oldImage.empty())
        numPixels = pickChangedPixels(oldImage, destroyableImage, numPixels);

    const int lastElt = 1 << bitDepth;
    const int splitElt = lastElt / 2;
    const int splitDist = splitElt / 2;

    splitPalette(destroyableImage, numPixels, 1, lastElt, splitElt, splitDist, 1,  pPal);

    // add the bottom node for the transparency index
    pPal.treeSplit[1 << (bitDepth - 1)] = 0;
    pPal.treeSplitElt[1 << (bitDepth - 1)] = 0;

    pPal.r[0] = pPal.g[0] = pPal.b[0] = 0;

    return pPal;
}

void GifWriter::splitPalette(
        std::vector<uint8_t> &image,
        int numPixels,
        int firstElt,
        int lastElt,
        int splitElt,
        int splitDist,
        int treeNode,
        GifPalette &pal
) {
    if (lastElt <= firstElt || numPixels == 0)
        return;

    // base case, bottom of the tree
    if (lastElt == firstElt + 1) {
        // take the average of all colors in this subcube
        uint64_t r = 0, g = 0, b = 0;
        for (int ii = 0; ii < numPixels; ++ii) {
            r += image[ii * 4 + 0];
            g += image[ii * 4 + 1];
            b += image[ii * 4 + 2];
        }

        r += (uint64_t) numPixels / 2;  // round to nearest
        g += (uint64_t) numPixels / 2;
        b += (uint64_t) numPixels / 2;

        r /= (uint64_t) numPixels;
        g /= (uint64_t) numPixels;
        b /= (uint64_t) numPixels;

        pal.r[firstElt] = (uint8_t) r;
        pal.g[firstElt] = (uint8_t) g;
        pal.b[firstElt] = (uint8_t) b;

        return;
    }

    // Find the axis with the largest range
    int minR = 255, maxR = 0;
    int minG = 255, maxG = 0;
    int minB = 255, maxB = 0;
    for (int ii = 0; ii < numPixels; ++ii) {
        int r = image[ii * 4 + 0];
        int g = image[ii * 4 + 1];
        int b = image[ii * 4 + 2];

        if (r > maxR) maxR = r;
        if (r < minR) minR = r;

        if (g > maxG) maxG = g;
        if (g < minG) minG = g;

        if (b > maxB) maxB = b;
        if (b < minB) minB = b;
    }

    int rRange = maxR - minR;
    int gRange = maxG - minG;
    int bRange = maxB - minB;

    // and split along that axis. (incidentally, this means this isn't a "proper" k-d tree but I don't know what else to call it)
    int splitCom = 1;
    if (bRange > gRange) splitCom = 2;
    if (rRange > bRange && rRange > gRange) splitCom = 0;

    int subPixelsA = numPixels * (splitElt - firstElt) / (lastElt - firstElt);
    int subPixelsB = numPixels - subPixelsA;

    partitionByMedian(image, 0, numPixels, splitCom, subPixelsA);

    pal.treeSplitElt[treeNode] = (uint8_t) splitCom;
    pal.treeSplit[treeNode] = image[subPixelsA * 4 + splitCom];

    splitPalette(image, subPixelsA, firstElt, splitElt, splitElt - splitDist, splitDist / 2, treeNode * 2, pal);
    auto temp = std::vector<uint8_t>{&image[subPixelsA * 4], &image[image.size()]};
    splitPalette(temp, subPixelsB, splitElt, lastElt, splitElt + splitDist, splitDist / 2,
                    treeNode * 2 + 1, pal);
}

std::vector<uint8_t> GifWriter::thresholdImage(
        const std::vector<uint8_t>& nextFrame,
        unsigned width,
        unsigned height,
        const GifPalette& pPal) {
    auto lastFrame = this->oldImage.begin();
    std::vector<uint8_t> outFrame{};
    uint32_t numPixels = width * height;
    for (uint32_t ii = 0; ii < numPixels; ++ii) {
        // if a previous color is available, and it matches the current color,
        // set the pixel to transparent
        if (!oldImage.empty() &&
            lastFrame[4*ii+0] == nextFrame[4*ii+0] &&
            lastFrame[4*ii+1] == nextFrame[4*ii+1] &&
            lastFrame[4*ii+2] == nextFrame[4*ii+2]) {
            outFrame[4*ii+0] = lastFrame[4*ii+0];
            outFrame[4*ii+1] = lastFrame[4*ii+1];
            outFrame[4*ii+2] = lastFrame[4*ii+2];
            outFrame[4*ii+3] = kGifTransIndex;
        } else {
            // palettize the pixel
            int32_t bestDiff = 1000000;
            int32_t bestInd = 1;
            getClosestPaletteColor(pPal, nextFrame[4 * ii + 0], nextFrame[4 * ii + 1], nextFrame[4 * ii + 2], bestInd, bestDiff, 1);

            // Write the resulting color to the output buffer
            outFrame.push_back(pPal.r[bestInd]);
            outFrame.push_back(pPal.g[bestInd]);
            outFrame.push_back(pPal.b[bestInd]);
            outFrame.push_back((uint8_t) bestInd);
        }
    }
    return outFrame;
}

void GifWriter::getClosestPaletteColor(const GifPalette &pPal, int r, int g, int b, int &bestInd, int &bestDiff, int treeRoot) {
    // base case, reached the bottom of the tree
    if (treeRoot > (1 << pPal.bitDepth) - 1) {
        int ind = treeRoot - (1 << pPal.bitDepth);
        if (ind == kGifTransIndex) return;

        // check whether this color is better than the current winner
        int r_err = r - ((int32_t) pPal.r[ind]);
        int g_err = g - ((int32_t) pPal.g[ind]);
        int b_err = b - ((int32_t) pPal.b[ind]);
        int diff = std::abs(r_err) + std::abs(g_err) + std::abs(b_err);

        if (diff < bestDiff) {
            bestInd = ind;
            bestDiff = diff;
        }

        return;
    }

    // take the appropriate color (r, g, or b) for this node of the k-d tree
    int comps[3] = {r, g, b};
    int splitComp = comps[pPal.treeSplitElt[treeRoot]];

    int splitPos = pPal.treeSplit[treeRoot];
    if (splitPos > splitComp) {
        // check the left subtree
        getClosestPaletteColor(pPal, r, g, b, bestInd, bestDiff, treeRoot * 2);
        if (bestDiff > splitPos - splitComp) {
            // cannot prove there's not a better value in the right subtree, check that too
            getClosestPaletteColor(pPal, r, g, b, bestInd, bestDiff, treeRoot * 2 + 1);
        }
    } else {
        getClosestPaletteColor(pPal, r, g, b, bestInd, bestDiff, treeRoot * 2 + 1);
        if (bestDiff > splitComp - splitPos) {
            getClosestPaletteColor(pPal, r, g, b, bestInd, bestDiff, treeRoot * 2);
        }
    }
}

void
GifWriter::writeLzwImage(
        const std::vector<uint8_t> &image,
        uint32_t left,
        uint32_t top,
        uint32_t width,
        uint32_t height,
        uint32_t delay,
        GifPalette &pPal
) {
    // graphics control extension
    file.put(0x21);
    file.put(0xf9);
    file.put(0x04);
    file.put(0x05); // leave prev frame in place, this frame has transparency
    file.put(delay & 0xff);
    file.put((delay >> 8) & 0xff);
    file.put(kGifTransIndex & 0xff); // transparent color index
    file.put(0);

    file.put(0x2c); // image descriptor block

    file.put(left & 0xff);           // corner of image in canvas space
    file.put((left >> 8) & 0xff);
    file.put(top & 0xff);
    file.put((top >> 8) & 0xff);

    file.put(width & 0xff);          // width and height of image
    file.put((width >> 8) & 0xff);
    file.put(height & 0xff);
    file.put((height >> 8) & 0xff);

    //file.put(0); // no local color table, no transparency
    //file.put(0x80); // no local color table, but transparency

    file.put(0x80 + pPal.bitDepth - 1); // local color table present, 2 ^ bitDepth entries
    writePalette(pPal);

    const unsigned minCodeSize = pPal.bitDepth;
    const uint32_t clearCode = 1 << pPal.bitDepth;

    file.put(minCodeSize); // min code size 8 bits

    std::vector<GifLzwNode> codeTree{4096, GifLzwNode{}};

    int32_t curCode = -1;
    uint32_t codeSize = (uint32_t) minCodeSize + 1;
    uint32_t maxCode = clearCode + 1;

    GifBitStatus stat{};
    stat.byte = 0;
    stat.bitIndex = 0;
    stat.chunkIndex = 0;

    writeCode(stat, clearCode, codeSize);  // start with a fresh LZW dictionary

    for (uint32_t yy = 0; yy < height; ++yy) {
        for (uint32_t xx = 0; xx < width; ++xx) {
            uint8_t nextValue = image[(yy * width + xx) * 4 + 3];
            // "loser mode" - no compression, every single code is followed immediately by a clear
            //WriteCode( f, stat, nextValue, codeSize );
            //WriteCode( f, stat, 256, codeSize );

            if (curCode < 0) {
                // first value in a new run
                curCode = nextValue;
            } else if (codeTree[curCode].m_next[nextValue]) {
                // current run already in the dictionary
                curCode = codeTree[curCode].m_next[nextValue];
            } else {
                // finish the current run, write a code
                writeCode(stat, (uint32_t) curCode, codeSize);

                // insert the new run into the dictionary
                codeTree[curCode].m_next[nextValue] = (uint16_t) ++maxCode;

                if (maxCode >= (1ul << codeSize)) {
                    // dictionary entry count has broken a size barrier,
                    // we need more bits for codes
                    codeSize++;
                }
                if (maxCode == 4095) {
                    // the dictionary is full, clear it out and begin anew
                    writeCode(stat, clearCode, codeSize); // clear tree

                    codeTree = {4096, GifLzwNode{}};
                    codeSize = (uint32_t) (minCodeSize + 1);
                    maxCode = clearCode + 1;
                }

                curCode = nextValue;
            }
        }
    }
    // compression footer
    writeCode(stat, (uint32_t) curCode, codeSize);
    writeCode(stat, clearCode, codeSize);
    writeCode(stat, clearCode + 1, (uint32_t) minCodeSize + 1);

    // write out the last partial chunk
    while (stat.bitIndex) writeBit(stat, 0);
    if (stat.chunkIndex) writeChunk(stat);

    file.put(0); // image block terminator
}

void GifWriter::writePalette(const GifPalette &pPal) {
    file.put(0);  // first color: transparency
    file.put(0);
    file.put(0);

    for (int ii = 1; ii < (1 << pPal.bitDepth); ++ii) {
        uint32_t r = pPal.r[ii];
        uint32_t g = pPal.g[ii];
        uint32_t b = pPal.b[ii];

        file.put((int)r);
        file.put((int)g);
        file.put((int)b);
    }

}

void GifWriter::writeCode(GifBitStatus &stat, uint32_t code, uint32_t length) {
    for (uint32_t ii = 0; ii < length; ++ii) {
        writeBit(stat, code);
        code = code >> 1;

        if (stat.chunkIndex == 255) {
            writeChunk(stat);
        }
    }

}

void GifWriter::writeBit(GifBitStatus &stat, uint32_t bit) {
    bit = bit & 1;
    bit = bit << stat.bitIndex;
    stat.byte |= bit;

    ++stat.bitIndex;
    if (stat.bitIndex > 7) {
        // move the newly-finished byte to the chunk buffer
        stat.chunk[stat.chunkIndex++] = stat.byte;
        // and start a new byte
        stat.bitIndex = 0;
        stat.byte = 0;
    }
}

void GifWriter::writeChunk(GifBitStatus& stat) {
    file.put(((int) stat.chunkIndex));
    file.write(reinterpret_cast<const char *>(stat.chunk), stat.chunkIndex);

    stat.bitIndex = 0;
    stat.byte = 0;
    stat.chunkIndex = 0;
}

void GifWriter::partitionByMedian(std::vector<uint8_t> &image, int left, int right, int com, int neededCenter) {
    if (left < right - 1) {
        int pivotIndex = left + (right - left) / 2;

        pivotIndex = partition(image, left, right, com, pivotIndex);

        // Only "sort" the section of the array that contains the median
        if (pivotIndex > neededCenter)
            partitionByMedian(image, left, pivotIndex, com, neededCenter);

        if (pivotIndex < neededCenter)
            partitionByMedian(image, pivotIndex + 1, right, com, neededCenter);
    }
}

int GifWriter::partition(std::vector<uint8_t> &image, const int left, const int right, const int elt, int pivotIndex) {
    const int pivotValue = image[(pivotIndex) * 4 + elt];
    swapPixels(image, pivotIndex, right - 1);
    int storeIndex = left;
    bool split = false;
    for (int ii = left; ii < right - 1; ++ii) {
        int arrayVal = image[ii * 4 + elt];
        if (arrayVal < pivotValue) {
            swapPixels(image, ii, storeIndex);
            ++storeIndex;
        } else if (arrayVal == pivotValue) {
            if (split) {
                swapPixels(image, ii, storeIndex);
                ++storeIndex;
            }
            split = !split;
        }
    }
    swapPixels(image, storeIndex, right - 1);
    return storeIndex;
}

int GifWriter::pickChangedPixels(const std::vector<uint8_t> &lastFrame, std::vector<uint8_t> &frame, int numPixels) {
    int numChanged = 0;
    auto writeIter = frame.begin();

    for (int ii = 0; ii < numPixels; ++ii) {
        if (lastFrame[4*ii+0] != frame[4*ii+0] ||
            lastFrame[4*ii+1] != frame[4*ii+1] ||
            lastFrame[4*ii+2] != frame[4*ii+2]) {
                writeIter[0] = frame[4*ii+0];
                writeIter[1] = frame[4*ii+1];
                writeIter[2] = frame[4*ii+2];
                ++numChanged;
                writeIter += 4;
        }
    }

    return numChanged;
}

void GifWriter::swapPixels(std::vector<uint8_t> &image, int pixA, int pixB) {
    uint8_t rA = image[pixA * 4];
    uint8_t gA = image[pixA * 4 + 1];
    uint8_t bA = image[pixA * 4 + 2];
    uint8_t aA = image[pixA * 4 + 3];

    uint8_t rB = image[pixB * 4];
    uint8_t gB = image[pixB * 4 + 1];
    uint8_t bB = image[pixB * 4 + 2];
    uint8_t aB = image[pixA * 4 + 3];

    image[pixA * 4] = rB;
    image[pixA * 4 + 1] = gB;
    image[pixA * 4 + 2] = bB;
    image[pixA * 4 + 3] = aB;

    image[pixB * 4] = rA;
    image[pixB * 4 + 1] = gA;
    image[pixB * 4 + 2] = bA;
    image[pixB * 4 + 3] = aA;
}


