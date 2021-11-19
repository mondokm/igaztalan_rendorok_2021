package com.igaztalan.backend.model

data class CaffUploadDTO(
    val title: String,
    val creatorId: Long,
    val keywords: List<String>,
    val base64Caff: String,
)
