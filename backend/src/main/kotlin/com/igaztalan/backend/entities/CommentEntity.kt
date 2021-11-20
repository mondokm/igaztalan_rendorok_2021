package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CommentEntity (
    @OneToOne
    val author: UserEntity,

    val message: String,

    val timestamp: Long,

    @OneToOne
    val caff: CaffEntity
) {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
}