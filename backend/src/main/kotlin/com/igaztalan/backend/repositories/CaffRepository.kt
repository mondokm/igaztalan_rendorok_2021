package com.igaztalan.backend.repositories

import com.igaztalan.backend.entities.CaffEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface CaffRepository: JpaRepository<CaffEntity, Long> {

    @Query("SELECT caff FROM CaffEntity caff JOIN caff.keywords k WHERE k = :keyword")
    fun findByKeyword(keyword: String): List<CaffEntity>

}