package com.igaztalan.backend.controller

import com.igaztalan.backend.model.LoginRequestDTO
import com.igaztalan.backend.model.LoginResponseDTO
import org.slf4j.LoggerFactory
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/user")
class UserController {

    private val logger = LoggerFactory.getLogger(this.javaClass)

    @PostMapping("/login")
    fun login(@RequestBody request: LoginRequestDTO): LoginResponseDTO {
        logger.info("${request.username} ${request.password}")
        return LoginResponseDTO("asd")
    }

    @GetMapping("/hello")
    fun hello() {
        logger.info("asd");
    }

}