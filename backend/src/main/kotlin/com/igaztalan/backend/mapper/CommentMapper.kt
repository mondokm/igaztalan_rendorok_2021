package com.igaztalan.backend.mapper

import com.igaztalan.backend.entities.CommentEntity
import com.igaztalan.backend.model.CommentDTO
import com.igaztalan.backend.model.CommentUploadDTO
import org.springframework.stereotype.Component

@Component
class CommentMapper(private val userMapper: UserMapper) {

    fun map(entity: CommentEntity) = CommentDTO(
        id = entity.id,
        message = entity.message,
        timestamp = entity.timestamp,
        author = userMapper.mapToBusiness(entity.author),
        caffId = entity.caff.id
    )

}