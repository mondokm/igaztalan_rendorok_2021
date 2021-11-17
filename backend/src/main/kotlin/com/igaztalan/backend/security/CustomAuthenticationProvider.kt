package com.igaztalan.backend.security

import org.springframework.security.authentication.AuthenticationProvider
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.stereotype.Component

@Component
class CustomAuthenticationProvider: AuthenticationProvider {

    override fun authenticate(authentication: Authentication): Authentication? {
        val name = authentication.name
        val password = authentication.credentials.toString()

        return if(true) UsernamePasswordAuthenticationToken(name, password, listOf())
        else null
    }

    override fun supports(authentication: Class<*>) =
        authentication == UsernamePasswordAuthenticationToken::class.java
}