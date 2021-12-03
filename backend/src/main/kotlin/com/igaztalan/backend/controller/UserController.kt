package com.igaztalan.backend.controller

import com.igaztalan.backend.entities.UserEntity
import com.igaztalan.backend.mapper.UserMapper
import com.igaztalan.backend.model.BusinessUserDTO
import com.igaztalan.backend.model.RegistrationDTO
import com.igaztalan.backend.repositories.RoleRepository
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.security.SecurityConstants.ROLE_USER
import com.igaztalan.backend.util.toNullable
import org.passay.PasswordData
import org.passay.PasswordValidator
import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.bind.annotation.*
import javax.websocket.server.PathParam

@RestController
@RequestMapping("/user")
class UserController(
    private val userRepository: UserRepository,
    private val roleRepository: RoleRepository,
    private val passwordEncoder: PasswordEncoder,
    private val userMapper: UserMapper,
    private val validator: PasswordValidator,
) {

    @PostMapping("/sign-up")
    fun signUp(@RequestBody user: RegistrationDTO): ResponseEntity<BusinessUserDTO> {
        if (userRepository.existsByName(user.name)) return ResponseEntity.badRequest().build()
        if (!validator.validate(PasswordData(user.password)).isValid) return ResponseEntity.badRequest().build()
        return ResponseEntity.ok(
            userRepository.save(
                UserEntity(
                    name = user.name,
                    password = passwordEncoder.encode(user.password),
                    roles = listOf(roleRepository.findByName(ROLE_USER)),
                    caffs = mutableListOf(),
                    comments = mutableListOf()
                )
            ).let(userMapper::mapToBusiness)
        )
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    fun delete(@PathVariable id: Long) = userRepository.findById(id).map { userRepository::delete }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    fun update(@RequestBody user: RegistrationDTO, @PathVariable id: Long): ResponseEntity<BusinessUserDTO> {
        if (userRepository.existsByName(user.name)) return ResponseEntity.badRequest().build()
        val userEntity = userRepository.findById(id).toNullable() ?: return ResponseEntity.badRequest().build()
        val newUserEntity = UserEntity(
            name = user.name,
            password = passwordEncoder.encode(user.password),
            roles = listOf(roleRepository.findByName(ROLE_USER)),
            caffs = userEntity.caffs,
            comments = userEntity.comments
        )
        userRepository.deleteById(id)
        newUserEntity.id = id;
        return ResponseEntity.ok(userRepository.save(newUserEntity).let{userMapper.mapToBusiness(it)})
    }

}