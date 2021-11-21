# Backend

This is the backend component of the CAFF webshop written in Kotlin using Spring.

## Setup

The following environment variables have to be set for the parser to work:
* `PARSER_PATH`: The absolute path of the folder that contains the CaffParser binary
* `WORKING_PATH`: The working directory of the parser, which will create the GIF files here

Setting the environment variables on linux:
```
export PARSER_PATH=/home/amyglassires/parser
export WORKING_PATH=/home/amyglassires/pictures
```

The backend can be built using gradle:
```
./gradlew build
```

## Execution

The server runs on the 8080 port and can be executed with the following command:
```
./gradlew bootRun
```