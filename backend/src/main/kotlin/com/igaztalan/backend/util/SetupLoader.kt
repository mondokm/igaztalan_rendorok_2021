package com.igaztalan.backend.util

import com.igaztalan.backend.entities.RoleEntity
import com.igaztalan.backend.entities.UserEntity
import com.igaztalan.backend.repositories.RoleRepository
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.security.SecurityConstants.ROLE_ADMIN
import com.igaztalan.backend.security.SecurityConstants.ROLE_USER
import org.springframework.context.ApplicationListener
import org.springframework.context.event.ContextRefreshedEvent
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component

@Component
class SetupLoader(
    private val roleRepository: RoleRepository,
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder,
): ApplicationListener<ContextRefreshedEvent> {
    override fun onApplicationEvent(event: ContextRefreshedEvent) {
        addRoles()

        addAdminUser()
    }

    fun addRoles(){
        roleRepository.save(RoleEntity(ROLE_USER))
        roleRepository.save(RoleEntity(ROLE_ADMIN))
    }

    fun addAdminUser(){
        userRepository.save(
            UserEntity(
                name = "admin",
                password = passwordEncoder.encode("admin"),
                roles = listOf(roleRepository.findByName(ROLE_ADMIN)),
                caffs = mutableListOf(),
                comments = mutableListOf()
            )
        )
        userRepository.save(
            UserEntity(
                name = "admin2",
                password = passwordEncoder.encode("admin"),
                roles = listOf(roleRepository.findByName(ROLE_ADMIN)),
                caffs = mutableListOf(),
                comments = mutableListOf()
            )
        )
    }
}