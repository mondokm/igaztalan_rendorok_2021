#include <iostream>
#include <cassert>
#include "CaffParser.h"

// parser -i /home/albert/my_husband.caff -o /home/albert/gifs/my_husband.caff
int main(int argv, const char* argc[]) {
    assert(argv == 4);
    assert(std::string(argc[0]) == "-i");
    const std::string inPath{argc[1]};
    assert(std::string(argc[2]) == "-o");
    const std::string outPath{argc[3]};

    CaffParser::generateGifFrom(inPath, outPath);
}
