package com.igaztalan.backend.security

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTDecodeException
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.security.SecurityConstants.HEADER_STRING
import com.igaztalan.backend.security.SecurityConstants.SECRET
import com.igaztalan.backend.security.SecurityConstants.TOKEN_PREFIX
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class JWTAuthorizationFilter(
    authenticationManager: AuthenticationManager,
    private val userRepository: UserRepository
) : BasicAuthenticationFilter(authenticationManager) {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain
    ) {
        val header = request.getHeader(HEADER_STRING)

        if (header != null && !header.startsWith(TOKEN_PREFIX)) {
            chain.doFilter(request, response)
        }

        val authentication = getAuthentication(request)

        SecurityContextHolder.getContext().authentication = authentication
        chain.doFilter(request, response)
    }

    private fun getAuthentication(request: HttpServletRequest): UsernamePasswordAuthenticationToken? {
        val token = request.getHeader(HEADER_STRING)

        if (token != null) {
            try {
                val user = JWT.require(Algorithm.HMAC512(SECRET.toByteArray()))
                    .build()
                    .verify(token.replace(TOKEN_PREFIX, ""))
                    .subject

                val appUser = userRepository.findByName(user)
                if (appUser != null) return UsernamePasswordAuthenticationToken(
                    user,
                    "",
                    appUser.roles.map { SimpleGrantedAuthority(it.name) }.toList()
                )
            } catch (e: JWTDecodeException) {
                return null
            }
        }

        return null
    }

}
