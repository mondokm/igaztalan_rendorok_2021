package com.igaztalan.backend.security

import com.igaztalan.backend.entities.RoleEntity
import com.igaztalan.backend.entities.UserEntity
import com.igaztalan.backend.repositories.UserRepository
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService

class UserDetailsServiceImpl(private val userRepository: UserRepository): UserDetailsService {
    override fun loadUserByUsername(username: String): UserDetails {
        val applicationUser: UserEntity = userRepository.findByName(username)
        return User(
            applicationUser.name,
            applicationUser.password,
            applicationUser.roles.map{SimpleGrantedAuthority(it.name)}.toList()
        )
    }
}