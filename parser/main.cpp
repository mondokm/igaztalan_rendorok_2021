#include <iostream>
#include "CaffParser.h"

int main(int argv, const char* argc[]) {
    if (argv != 5 || std::string(argc[1]) != "-i" || std::string(argc[3]) != "-o") {
        std::cout << "Usage: ./parser -i /path/to/input/file.png -o /path/to/output/file.gif" << std::endl;
        return -1;
    }

    const std::string inPath{argc[2]};
    const std::string outPath{argc[4]};

    return CaffParser::generateGifFrom(inPath, outPath);
}
