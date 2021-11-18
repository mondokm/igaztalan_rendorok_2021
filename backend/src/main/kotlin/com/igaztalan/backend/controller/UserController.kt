package com.igaztalan.backend.controller

import com.igaztalan.backend.entities.UserEntity
import com.igaztalan.backend.mapper.UserMapper
import com.igaztalan.backend.model.BusinessUserDTO
import com.igaztalan.backend.model.RegistrationDTO
import com.igaztalan.backend.repositories.RoleRepository
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.security.SecurityConstants.ROLE_USER
import org.slf4j.LoggerFactory
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/user")
class UserController(
    private val userRepository: UserRepository,
    private val roleRepository: RoleRepository,
    private val passwordEncoder: PasswordEncoder,
    private val userMapper: UserMapper
) {

    private val logger = LoggerFactory.getLogger(this.javaClass)

    @GetMapping("/hello")
    fun hello() {
        logger.info("asd");
    }

    @PostMapping("/sign-up")
    fun signUp(@RequestBody user: RegistrationDTO): BusinessUserDTO =
        // TODO check if user already exists
         userRepository.save(
            UserEntity(
                name = user.name,
                password = passwordEncoder.encode(user.password),
                roles = listOf(roleRepository.findByName(ROLE_USER))
            )
        ).let(userMapper::mapToBusiness)

}