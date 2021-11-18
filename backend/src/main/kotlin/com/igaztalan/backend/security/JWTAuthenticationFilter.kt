package com.igaztalan.backend.security

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.igaztalan.backend.model.LoginRequestDTO
import com.igaztalan.backend.repositories.UserRepository
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.User
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import java.util.*
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import com.igaztalan.backend.security.SecurityConstants.EXPIRATION_TIME
import com.igaztalan.backend.security.SecurityConstants.HEADER_STRING
import com.igaztalan.backend.security.SecurityConstants.ROLE_ADMIN
import com.igaztalan.backend.security.SecurityConstants.SECRET
import com.igaztalan.backend.security.SecurityConstants.TOKEN_PREFIX
import org.springframework.security.core.authority.SimpleGrantedAuthority

class JWTAuthenticationFilter(
    authenticationManager: AuthenticationManager,
    private val userRepository: UserRepository
): UsernamePasswordAuthenticationFilter(authenticationManager) {

    override fun attemptAuthentication(request: HttpServletRequest, response: HttpServletResponse): Authentication {
        val user = jacksonObjectMapper().readValue(request.inputStream, LoginRequestDTO::class.java)
        return authenticationManager.authenticate(
            UsernamePasswordAuthenticationToken(
                user.name,
                user.password,
                listOf()
            )
        )
    }

    override fun successfulAuthentication(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
        authResult: Authentication
    ) {
        val user = authResult.principal as User
        val token = JWT.create()
            .withSubject(user.username)
            .withExpiresAt(Date(System.currentTimeMillis() + EXPIRATION_TIME))
            .sign(Algorithm.HMAC512(SECRET.toByteArray()))
        response.addHeader(HEADER_STRING, TOKEN_PREFIX + token)
        response.addHeader("isAdmin", if (user.authorities.contains(SimpleGrantedAuthority(ROLE_ADMIN))) "1" else "0")
        response.addHeader("userId", userRepository.findByName(user.username)?.id.toString())
    }
}