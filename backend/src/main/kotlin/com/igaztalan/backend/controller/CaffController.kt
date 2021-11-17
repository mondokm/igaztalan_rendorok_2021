package com.igaztalan.backend.controller

import com.igaztalan.backend.mapper.CaffDescriptorMapper
import com.igaztalan.backend.mapper.CommentMapper
import com.igaztalan.backend.mapper.UserMapper
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.repositories.CaffDescriptorRepository
import com.igaztalan.backend.repositories.CommentRepository
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/caff")
class CaffController(
    private val caffDescriptorRepository: CaffDescriptorRepository,
    private val userRepository: UserRepository,
    private val commentRepository: CommentRepository,
    private val caffDescriptorMapper: CaffDescriptorMapper,
    private val commentMapper: CommentMapper,
    private val userMapper: UserMapper,
) {

    @GetMapping("/")
    fun getAll() = caffDescriptorRepository.findAll().map(caffDescriptorMapper::map).toList()

}