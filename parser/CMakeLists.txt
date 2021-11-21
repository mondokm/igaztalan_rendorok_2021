cmake_minimum_required(VERSION 3.18)
project(CaffParser)

set(CMAKE_CXX_STANDARD 20)
set(GCC_COVERAGE_COMPILE_FLAGS "-fstack-protector")

add_executable(CaffParser main.cpp CaffParser.cpp CaffParser.h GifWriter.cpp GifWriter.h)
