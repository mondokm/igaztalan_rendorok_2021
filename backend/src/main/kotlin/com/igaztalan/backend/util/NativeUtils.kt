package com.igaztalan.backend.util

import java.io.File
import java.nio.file.Files
import java.util.*
import java.util.concurrent.TimeUnit

fun File.encodeToBase64(): String =
    Base64.getEncoder().encodeToString(Files.readAllBytes(toPath()))

fun String.decodeBase64(): ByteArray = Base64.getDecoder().decode(this)

val PARSER_PATH = System.getenv("PARSER_PATH")
val WORKING_PATH = System.getenv("WORKING_PATH")

class ParserException(
    message: String
) : RuntimeException(message)

fun String.runCommand(
    workingDir: File = File("."),
    timeoutAmount: Long = 60,
    timeoutUnit: TimeUnit = TimeUnit.SECONDS
): Int = runCatching {
        ProcessBuilder("\\s".toRegex().split(this))
            .directory(workingDir)
            .redirectOutput(ProcessBuilder.Redirect.PIPE)
            .redirectError(ProcessBuilder.Redirect.PIPE)
            .start().run {
                waitFor(timeoutAmount, timeoutUnit)
                exitValue()
            }
    }.onFailure { it.printStackTrace() }.getOrDefault(-1)

fun runParser(inputFileName: String, outputFileName: String) {
    "./CaffParser -i $inputFileName -o $outputFileName".runCommand(
        workingDir = File(PARSER_PATH),
    ).let {
        println("Parser gave $it")
        if (it != 0) throw ParserException("Parsing failed!")
    }
}

fun saveCaffAndPreview(base64Caff: String, id: Long): Int {
    val inputPath = "$WORKING_PATH/$id.caff"
    val outputPath = "$WORKING_PATH/$id.gif"

    File(inputPath).writeBytes(base64Caff.decodeBase64())

    runParser(inputPath, outputPath)

    return 0
}

fun readCaff(id: Long): String {
    val path = "$WORKING_PATH/$id.caff"
    return File(path).encodeToBase64()
}

fun readPreview(id: Long): String {
    val path = "$WORKING_PATH/$id.gif"
    return File(path).encodeToBase64()
}
