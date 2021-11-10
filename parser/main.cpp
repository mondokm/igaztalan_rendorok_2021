#include <iostream>
#include <cassert>
#include "CaffParser.h"

int main(int argv, const char* argc[]) {
    assert(argv == 5);
    assert(std::string(argc[1]) == "-i");
    const std::string inPath{argc[2]};
    assert(std::string(argc[3]) == "-o");
    const std::string outPath{argc[4]};

    return CaffParser::generateGifFrom(inPath, outPath);
}
