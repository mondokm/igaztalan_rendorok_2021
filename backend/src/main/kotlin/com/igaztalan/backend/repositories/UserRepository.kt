package com.igaztalan.backend.repositories

import com.igaztalan.backend.entities.UserEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRepository: JpaRepository<UserEntity, Long> {

    fun findByName(name: String): UserEntity?

    fun existsByName(name: String): Boolean

}