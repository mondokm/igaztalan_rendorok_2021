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
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.io.IOException

@RestController
@RequestMapping("/caff")
class CaffController(
    private val caffRepository: CaffRepository,
    private val userRepository: UserRepository,
    private val commentRepository: CommentRepository,
    private val caffMapper: CaffMapper,
    private val commentMapper: CommentMapper,
) {

    @GetMapping("/descriptor")
    fun getAll() = ResponseEntity.ok(CaffDescriptorListDTO(caffRepository.findAll().map {
        val base64Preview = try {
            readPreview(it.id)
        } catch (e: IOException) {
            e.printStackTrace()
            return ResponseEntity.internalServerError().build<CaffDescriptorListDTO>()
        }
        caffMapper.mapToDescriptor(it, base64Preview)
    }.toList()))

    @GetMapping("/descriptor/{id}")
    fun getDescriptorById(@PathVariable id: Long): ResponseEntity<CaffDescriptorDTO> =
        caffRepository.findById(id).toNullable()?.let {
            val base64Preview = readPreview(it.id)
            ResponseEntity.ok(caffMapper.mapToDescriptor(it, base64Preview))
        } ?: ResponseEntity.notFound().build()

    @GetMapping("/full/{id}")
    fun getFullById(@PathVariable id: Long): ResponseEntity<CaffFullDTO> =
        caffRepository.findById(id).toNullable()?.let {
            val base64Caff = readCaff(it.id)
            ResponseEntity.ok(CaffFullDTO(base64Caff))
        } ?: ResponseEntity.notFound().build()

    @PostMapping("/upload")
    @PreAuthorize("hasRole('ROLE_ADMIN') or @securityUtil.hasUserId(#authentication,#caffUploadDTO.creatorId)")
    fun upload(@RequestBody caffUploadDTO: CaffUploadDTO): ResponseEntity<CaffDescriptorDTO> {
        caffUploadDTO.run {
            val creator = userRepository.findById(creatorId).toNullable() ?: return ResponseEntity.badRequest().build()
            val entity = caffRepository.save(
                CaffEntity(
                    title = title,
                    comments = mutableListOf(),
                    keywords = keywords,
                    creator = creator,
                )
            )
            try {
                saveCaffAndPreview(caffUploadDTO.base64Caff, entity.id)
                val base64Preview = readPreview(entity.id)
                return ResponseEntity.ok(caffMapper.mapToDescriptor(entity, base64Preview))
            } catch (e: Exception) {
                caffRepository.findById(entity.id).map(caffRepository::delete)
                return ResponseEntity.internalServerError().build()
            }
        }
    }

    @PostMapping("/comment")
    @PreAuthorize("hasRole('ROLE_ADMIN') or @securityUtil.hasUserId(#authentication,#commentUploadDTO.authorId)")
    fun uploadComment(@RequestBody commentUploadDTO: CommentUploadDTO): ResponseEntity<CommentDTO> {
        val author =
            userRepository.findById(commentUploadDTO.authorId).toNullable() ?: return ResponseEntity.badRequest()
                .build()
        val caff =
            caffRepository.findById(commentUploadDTO.caffId).toNullable() ?: return ResponseEntity.badRequest().build()
        val comment = commentRepository.save(
            CommentEntity(
                author = author,
                message = commentUploadDTO.message,
                timestamp = commentUploadDTO.timestamp,
                caff = caff
            )
        )
//        caff.comments.add(comment)
//        caffRepository.save(caff)
        return ResponseEntity.ok(commentMapper.map(comment))
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    fun delete(@PathVariable id: Long) = caffRepository.deleteById(id)

    @GetMapping("/find")
    fun search(@RequestParam keyword: String) =
        ResponseEntity.ok(CaffDescriptorListDTO(
            caffs = caffRepository.findByKeyword(keyword).map {
                val base64Preview = try {
                    readPreview(it.id)
                } catch (e: IOException) {
                    return ResponseEntity.internalServerError().build<CaffDescriptorListDTO>()
                }
                caffMapper.mapToDescriptor(it, base64Preview)
            }
        ))

}
