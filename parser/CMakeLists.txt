cmake_minimum_required(VERSION 3.20)
project(CaffParser)

set(CMAKE_CXX_STANDARD 20)

add_executable(CaffParser main.cpp CaffParser.cpp CaffParser.h GifWriter.cpp GifWriter.h)
