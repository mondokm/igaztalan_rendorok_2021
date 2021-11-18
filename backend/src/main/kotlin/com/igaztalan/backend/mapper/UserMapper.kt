package com.igaztalan.backend.mapper

import com.igaztalan.backend.entities.UserEntity
import com.igaztalan.backend.model.BusinessUserDTO
import com.igaztalan.backend.model.RegistrationDTO
import org.springframework.stereotype.Component

@Component
class UserMapper {

    fun mapToBusiness(entity: UserEntity) = BusinessUserDTO(
        name = entity.name,
        id = entity.id,
    )

}