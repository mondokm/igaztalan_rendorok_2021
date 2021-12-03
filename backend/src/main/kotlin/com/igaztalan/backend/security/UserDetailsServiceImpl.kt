package com.igaztalan.backend.security

import com.igaztalan.backend.repositories.UserRepository
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service

@Service
class UserDetailsServiceImpl(private val userRepository: UserRepository) : UserDetailsService {
    override fun loadUserByUsername(username: String): UserDetails {
        val applicationUser = userRepository.findByName(username) ?: throw UsernameNotFoundException(username)
        return User(
            applicationUser.name,
            applicationUser.password,
            applicationUser.roles.map { SimpleGrantedAuthority(it.name) }.toList()
        )
    }
}
