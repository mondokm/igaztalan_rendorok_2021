package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CommentEntity (
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    @OneToOne
    val author: UserEntity,

    val message: String,

    val timestamp: Long,
)