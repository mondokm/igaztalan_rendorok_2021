package com.igaztalan.backend.controller

import com.igaztalan.backend.entities.CaffEntity
import com.igaztalan.backend.entities.CommentEntity
import com.igaztalan.backend.mapper.CaffMapper
import com.igaztalan.backend.mapper.CommentMapper
import com.igaztalan.backend.model.*
import com.igaztalan.backend.repositories.UserRepository
import com.igaztalan.backend.repositories.CaffRepository
import com.igaztalan.backend.repositories.CommentRepository
import com.igaztalan.backend.util.*
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
    fun getAll() = CaffDescriptorListDTO(caffRepository.findAll().map{
        val base64Preview = readPreview(it.id)
        caffMapper.mapToDescriptor(it, base64Preview)
    }.toList())

    @GetMapping("/descriptor/{id}")
    fun getDescriptorById(@PathVariable id: Long): CaffDescriptorDTO? =
        caffRepository.findById(id).toNullable()?.let{
            val base64Preview = readPreview(it.id)
            return caffMapper.mapToDescriptor(it, base64Preview)
        }

    @GetMapping("/full/{id}")
    fun getFullById(@PathVariable id: Long): CaffFullDTO? =
        caffRepository.findById(id).toNullable()?.let{
            val base64Caff = readCaff(it.id)
            return CaffFullDTO(base64Caff)
        }

    @PostMapping("/upload")
    fun upload(@RequestBody caffUploadDTO: CaffUploadDTO): CaffDescriptorDTO?{
        caffUploadDTO.run {
            val creator = userRepository.findById(creatorId).toNullable() ?: return null
            val entity = caffRepository.save(CaffEntity(
                title = title,
                comments = mutableListOf(),
                keywords = keywords,
                creator = creator,
            ))
            saveCaffAndPreview(caffUploadDTO.base64Caff, entity.id);
            val base64Preview = readPreview(entity.id)
            return caffMapper.mapToDescriptor(entity, base64Preview)
        }
    }

    @PostMapping("/comment")
    fun uploadComment(@RequestBody commentUploadDTO: CommentUploadDTO): CommentDTO? {
        val author = userRepository.findById(commentUploadDTO.authorId).toNullable() ?: return null
        val caff = caffRepository.findById(commentUploadDTO.caffId).toNullable() ?: return null
        val comment = commentRepository.save(CommentEntity(
            author = author,
            message = commentUploadDTO.message,
            timestamp = commentUploadDTO.timestamp,
            caff = caff
        ))
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
            caffs = caffRepository.findByKeyword(keyword).map{
                val base64Preview = readPreview(it.id)
                caffMapper.mapToDescriptor(it, base64Preview)
            }
        )

}