package com.igaztalan.backend.model

data class CaffDescriptorDTO(
    val title: String,
    val id: Long,
    val creatorId: Long,
    val base64Preview: String,
    val keywords: List<String>,
    val comments: List<CommentDTO>
)
