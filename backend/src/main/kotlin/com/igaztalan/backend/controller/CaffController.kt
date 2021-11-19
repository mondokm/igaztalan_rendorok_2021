package com.igaztalan.backend.controller

import com.igaztalan.backend.entities.CaffEntity
import com.igaztalan.backend.entities.CommentEntity
import com.igaztalan.backend.mapper.CaffMapper
import com.igaztalan.backend.mapper.CommentMapper
import com.igaztalan.backend.model.*
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.repositories.CaffRepository
import com.igaztalan.backend.repositories.CommentRepository
import com.igaztalan.backend.util.generateBase64Preview
import com.igaztalan.backend.util.toNullable
import org.slf4j.LoggerFactory
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/caff")
class CaffController(
    private val caffRepository: CaffRepository,
    private val userRepository: UserRepository,
    private val commentRepository: CommentRepository,
    private val caffMapper: CaffMapper,
    private val commentMapper: CommentMapper,
) {

    private val logger = LoggerFactory.getLogger(this.javaClass)

    @GetMapping("/descriptor")
    fun getAll() = CaffDescriptorListDTO(caffRepository.findAll().map(caffMapper::mapToDescriptor).toList())

    @GetMapping("/descriptor/{id}")
    fun getDescriptorById(@PathVariable id: Long): CaffDescriptorDTO? =
        caffRepository.findById(id).toNullable()?.let{caffMapper.mapToDescriptor(it)}

    @GetMapping("/full/{id}")
    fun getFullById(@PathVariable id: Long): CaffFullDTO? =
        caffRepository.findById(id).toNullable()?.let{
            logger.info("$it")
            caffMapper.mapToFull(it)
        }

    @PostMapping("/upload")
    fun upload(@RequestBody caffUploadDTO: CaffUploadDTO): CaffDescriptorDTO?{
        val creator = userRepository.findById(caffUploadDTO.creatorId).toNullable() ?: return null
        return caffRepository.save(CaffEntity(
            name = caffUploadDTO.name,
            comments = mutableListOf(),
            keywords = caffUploadDTO.keywords,
            base64Caff = caffUploadDTO.base64Caff,
            base64Preview = generateBase64Preview(caffUploadDTO.base64Caff),
            creator = creator,
        )).let{caffMapper.mapToDescriptor(it)}
    }

    @PostMapping("/comment")
    fun uploadComment(@RequestBody commentUploadDTO: CommentUploadDTO): CommentDTO? {
        val author = userRepository.findById(commentUploadDTO.authorId).toNullable() ?: return null
        val caff = caffRepository.findById(commentUploadDTO.caffId).toNullable() ?: return null
        val comment = CommentEntity(
            author = author,
            message = commentUploadDTO.message,
            timestamp = commentUploadDTO.timestamp,
            caff = caff
        )
        caff.comments.add(comment)
        caffRepository.save(caff)
        return commentMapper.map(comment)
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    fun delete(@PathVariable id: Long) = caffRepository.deleteById(id)

    @GetMapping("/find")
    fun search(@RequestParam keyword: String) =
        CaffDescriptorListDTO(
            caffs = caffRepository.findByKeyword(keyword).map(caffMapper::mapToDescriptor)
        )

}