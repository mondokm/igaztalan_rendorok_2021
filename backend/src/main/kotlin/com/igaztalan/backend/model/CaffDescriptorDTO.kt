package com.igaztalan.backend.model

data class CaffDescriptorDTO(val name: String, val id: Long, val creatorID: Long, val keywords: List<String>, val comments: List<CommentDTO>)
