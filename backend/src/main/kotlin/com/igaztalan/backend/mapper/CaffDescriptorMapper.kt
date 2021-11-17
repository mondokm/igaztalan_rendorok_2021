package com.igaztalan.backend.mapper

import com.igaztalan.backend.entities.CaffDescriptorEntity
import com.igaztalan.backend.model.CaffDescriptorDTO
import org.springframework.stereotype.Component

@Component
class CaffDescriptorMapper(private val commentMapper: CommentMapper) {

    fun map(entity: CaffDescriptorEntity) = CaffDescriptorDTO(
        name = entity.name,
        id = entity.id,
        creatorID = entity.creator.id,
        keywords = entity.keywords,
        comments = entity.comments.map(commentMapper::map).toList()
    )

}