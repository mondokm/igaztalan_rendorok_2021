#include <filesystem>
#include <utility>
#include <iostream>
#include <ranges>
#include <cassert>
#include "CaffParser.h"

int CaffParser::generateGifFrom(const std::filesystem::path& inPath, const std::filesystem::path& outPath) {
    if (inPath.extension() != ".caff")
        return -1;

    if (!std::filesystem::exists(inPath))
        return -1;

//    if (std::filesystem::exists(outPath))
//        return 0;

    Caff caff = loadCaff(inPath);

    try {
        auto blocks = caffToBlocks(caff);
        auto numAnimations = getNumAnimations(blocks[0]);

        std::erase_if(blocks, [] (const Block& b) { return b.getType() != Block::animation; });
        assert(blocks.size() == numAnimations);
        saveGif(blocks, outPath);
    } catch (std::exception&) {
        std::cout << "Invalid file format." << std::endl;
        return -1;
    }

    return 0;
}

Caff CaffParser::loadCaff(const std::filesystem::path& path) {
    std::ifstream stream{path, std::ios::binary | std::ios::in};
    return Caff{std::istreambuf_iterator<char>(stream), {}};
}

std::vector<CaffParser::Block> CaffParser::caffToBlocks(Caff caff) {
    std::vector<CaffParser::Block> blocks;
    while (!caff.empty()) {
        auto type = caff[0];
        auto length = bytesToLong({&caff[1], &caff[9]});
        std::vector<uint8_t> data = {&caff[9], &caff[10 + length - 1]};

        blocks.emplace_back(type = type, length = length, data = data);

        caff = {&caff[10 + length - 1], &caff[caff.size()]};
    }
    return blocks;
}

unsigned long long CaffParser::bytesToLong(const std::vector<uint8_t>& bytes) {
    unsigned long long value = 0;
    for (size_t i = bytes.size() - 1; i --> 0;) {
        value = value << 8;
        value |= bytes[i];
    }
    return value;
}

void CaffParser::saveGif(const std::vector<Block>& ciffBlocks, const std::string& fileName) {
    std::vector<Frame> frames{};
    for (const Block& block : ciffBlocks) {
        const auto& data = block.getData();

        unsigned long long msDuration = bytesToLong({&data[0], &data[8]});

        const std::vector<uint8_t> ciff = {&data[8], &data[data.size()]};

        assert(std::vector<uint8_t>(&ciff[0], &ciff[4]) == Frame::ciffMagic());

        unsigned long long headerLength = bytesToLong({&ciff[4], &ciff[12]});
        unsigned long long width = bytesToLong({&ciff[20], &ciff[28]});
        unsigned long long height = bytesToLong({&ciff[28], &ciff[36]});

//        auto captionEndIndex = std::distance(ciff.begin(), std::find(ciff.begin() + 36, ciff.end(), '\n'));

        std::vector<uint8_t> imageData = {};
        for (auto iter = ciff.begin() + headerLength; iter != ciff.end(); iter += 3) {
            imageData.push_back(*iter);
            imageData.push_back(*(iter+1));
            imageData.push_back(*(iter+2));
            imageData.push_back(0xff);
        }

        frames.emplace_back(imageData, width, height, msDuration);
    }
    if (frames.empty())
        return;

    GifWriter gifWriter(fileName, frames[0].width, frames[0].height, frames[0].msDuration/10);
    for (const Frame& frame : frames)
        gifWriter.writeFrame(frame.imageData, frame.width, frame.height, frame.msDuration/10);
}

const std::vector<uint8_t> &CaffParser::caffMagic() {
    static std::vector<uint8_t> CAFF_MAGIC{'C', 'A', 'F', 'F'};
    return CAFF_MAGIC;
}

unsigned long long CaffParser::getNumAnimations(const CaffParser::Block &firstBlock) {
    assert(firstBlock.getType() == Block::header);
    const auto& data = firstBlock.getData();
    unsigned long long numAnimations = bytesToLong({&data[12], &data[20]});
    return numAnimations;
}

CaffParser::Block::Block(
        unsigned int type,
        unsigned long long length,
        std::vector<uint8_t> data
): type{static_cast<Type>(type)}, length{length}, data{std::move(data)} {
    assert(this->data.size() == this->length);
    if (type == Type::header) {
        assert(std::vector<uint8_t>(&this->data[0], &this->data[4]) == caffMagic());
    }
}

CaffParser::Block::Type CaffParser::Block::getType() const {
    return type;
}

const std::vector<uint8_t> &CaffParser::Block::getData() const {
    return data;
}

CaffParser::Frame::Frame(std::vector<uint8_t> imageData,
                         unsigned long long width,
                         unsigned long long height,
                         unsigned long long msDuration
) : imageData(std::move(imageData)), width(width), height(height), msDuration(msDuration) {
    assert(this->imageData.size() == width * height * 4);
}

const std::vector<uint8_t>& CaffParser::Frame::ciffMagic() {
    static std::vector<uint8_t> CIFF_MAGIC{'C', 'I', 'F', 'F'};
    return CIFF_MAGIC;
}
