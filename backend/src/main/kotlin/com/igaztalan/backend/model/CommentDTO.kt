package com.igaztalan.backend.model

data class CommentDTO(
    val id: Long,
    val author: BusinessUserDTO,
    val message: String,
    val timestamp: Long,
)