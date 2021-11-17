package com.igaztalan.backend.repositories

import com.igaztalan.backend.entities.CaffDescriptorEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface CaffDescriptorRepository: JpaRepository<CaffDescriptorEntity, Long> {
}