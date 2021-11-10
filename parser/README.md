# Caff Parser
The Caff Parser transforms the input CAFF files to GIF files. 
## Build
You can build the Caff Parser using the following command: 
```shell
cmake CMakeLists.txt && make
```

## Run
You can run the Caff Parser using the following command:
```shell
./CaffParser -i /path/to/input.caff -o /path/to/output.gif
```

## Used libraries
We used the [GIF_h](https://github.com/charlietangora/gif-h) library which we
rewrote to match the standards of C++20 (no raw pointers, safe memory handling).

## Memory safety
To make the parser safe, we didn't use any format string methods, nor raw pointers in
order to avoid buffer overflows. 

We used the `-fstack-protector` GCC flag to enable stack smashing protection.
