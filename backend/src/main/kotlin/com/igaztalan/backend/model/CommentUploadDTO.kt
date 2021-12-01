package com.igaztalan.backend.model

data class CommentUploadDTO(
    val caffId: Long,
    val authorId: Long,
    val message: String,
    val timestamp: Long,
)
