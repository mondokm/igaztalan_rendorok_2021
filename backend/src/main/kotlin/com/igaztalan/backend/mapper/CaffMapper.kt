package com.igaztalan.backend.mapper

import com.igaztalan.backend.entities.CaffEntity
import com.igaztalan.backend.model.CaffDescriptorDTO
import org.springframework.stereotype.Component

@Component
class CaffMapper(private val commentMapper: CommentMapper) {

    fun mapToDescriptor(entity: CaffEntity, base64Preview: String) = CaffDescriptorDTO(
        title = entity.title,
        id = entity.id,
        creatorId = entity.creator.id,
        keywords = entity.keywords,
        comments = entity.comments.map(commentMapper::map).toList(),
        base64Preview = base64Preview,
    )

}