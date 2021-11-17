package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CommentEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @OneToOne
    var author = UserEntity()

    var message: String = ""

    var timestamp: Long = 0
}