#ifndef CAFFPARSER_H
#define CAFFPARSER_H

#include <string>
#include <vector>
#include "GifWriter.h"

using Caff = std::vector<uint8_t>;

class CaffParser {
protected:
    class Block {
    public:
        enum Type { header = 0x1, credits = 0x2, animation = 0x3, };
        Block(unsigned int type, unsigned long long length, std::vector<uint8_t>);
    private:
        Type type;
        unsigned long long length;
        std::vector<uint8_t> data;
    public:
        [[nodiscard]] Type getType() const;
        [[nodiscard]] const std::vector<uint8_t> &getData() const;
    };
    struct Frame {
        static const std::vector<uint8_t>& ciffMagic();
        std::vector<uint8_t> imageData;
        unsigned long long width, height, msDuration;

        Frame(std::vector<uint8_t> imageData, unsigned long long int width, unsigned long long int height, unsigned long long int msDuration);
    };
public:
    static int generateGifFrom(const std::filesystem::path& inPath, const std::filesystem::path& outPath);
    static const std::vector<uint8_t>& caffMagic();
private:
    static std::vector<uint8_t> loadCaff(const std::filesystem::path&);
    static std::vector<Block> caffToBlocks(Caff);
    static unsigned long long bytesToLong(const std::vector<uint8_t>&);
    static void saveGif(const std::vector<Block>&, const std::string& fileName);
    static unsigned long long getNumAnimations(const Block &firstBlock);
};

#endif //CAFFPARSER_H
