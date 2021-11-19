package com.igaztalan.backend.util

import java.io.File
import java.nio.file.Files
import java.util.*

fun encodeFileToBase64(file: File): String {
    return Base64.getEncoder().encodeToString(Files.readAllBytes(file.toPath()))
}

fun decodeBase64File(base64: String): ByteArray = Base64.getDecoder().decode(base64)

fun generateBase64Preview(base64Caff: String): String{
    // TODO preview generation
    return ""
}