// A modern C++ reimplementation of the library gif-h
// Original code is available at the following URL:
// https://github.com/charlietangora/gif-h

#ifndef CAFFPARSER_GIFWRITER_H
#define CAFFPARSER_GIFWRITER_H

#include <fstream>
#include <vector>
#include <filesystem>

struct GifPalette {
    unsigned bitDepth;

    uint8_t r[256];
    uint8_t g[256];
    uint8_t b[256];

    // k-d tree over RGB space, organized in heap fashion
    // i.e. left child of node i is node i*2, right child is node i*2+1
    // nodes 256-511 are implicitly the leaves, containing a color
    uint8_t treeSplitElt[256];
    uint8_t treeSplit[256];
};

struct GifLzwNode {
    uint16_t m_next[256];
};

struct GifBitStatus {
    uint8_t bitIndex;  // how many bits in the partial byte written so far
    uint8_t byte;      // current partial byte

    uint32_t chunkIndex;
    uint8_t chunk[256];   // bytes are written in here until we have 256 of them, then written to the file
};

const int kGifTransIndex = 0;

class GifWriter {
private:
    std::ofstream file;
    std::vector<uint8_t> oldImage = {};

    void writePalette( const GifPalette& pPal);
    void writeLzwImage(const std::vector<uint8_t>& image, uint32_t left, uint32_t top,  uint32_t width, uint32_t height, uint32_t delay, GifPalette& pPal);
    GifPalette makePalette(const std::vector<uint8_t>& frame, unsigned width, unsigned height, unsigned bitDepth);
    void splitPalette(std::vector<uint8_t>& image, int numPixels, int firstElt, int lastElt, int splitElt, int splitDist, int treeNode, GifPalette& pal);
    std::vector<uint8_t> thresholdImage(const std::vector<uint8_t>& nextFrame, unsigned width, unsigned height, const GifPalette&);
    void getClosestPaletteColor(const GifPalette& pPal, int r, int g, int b, int& bestInd, int& bestDiff, int treeRoot);
    void writeCode(GifBitStatus& stat, uint32_t code, uint32_t length );
    void writeBit(GifBitStatus& stat, uint32_t bit);
    void writeChunk(GifBitStatus& stat);
    void partitionByMedian(std::vector<uint8_t>& image, int left, int right, int com, int neededCenter);
    int partition(std::vector<uint8_t>& image, int left, int right, int elt, int pivotIndex);
    void swapPixels(std::vector<uint8_t>& image, int pixA, int pixB);
    int pickChangedPixels(const std::vector<uint8_t>& lastFrame, std::vector<uint8_t>& frame, int numPixels);
public:
    GifWriter(const std::filesystem::path&, unsigned width, unsigned height, unsigned delay);
    void writeFrame(const std::vector<uint8_t>& image, unsigned width, unsigned height, unsigned delay, unsigned bitDepth = 8);
    virtual ~GifWriter();
};


#endif //CAFFPARSER_GIFWRITER_H
