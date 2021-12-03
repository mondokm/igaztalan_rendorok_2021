package com.igaztalan.backend.util

import com.igaztalan.backend.entities.UserEntity
import com.igaztalan.backend.repositories.UserRepository
import org.springframework.security.core.Authentication
import org.springframework.stereotype.Component

@Component
class SecurityUtil(
    private val userRepository: UserRepository,
) {

    fun hasUserId(authentication: Authentication, userId: Long): Boolean {
        val user: UserEntity = userRepository.findByName(authentication.name) ?: return false
        return userId == user.id
    }

}
