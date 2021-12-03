package com.igaztalan.backend.repositories

import com.igaztalan.backend.entities.RoleEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface RoleRepository: JpaRepository<RoleEntity, Long> {

    fun findByName(name: String): RoleEntity

}
