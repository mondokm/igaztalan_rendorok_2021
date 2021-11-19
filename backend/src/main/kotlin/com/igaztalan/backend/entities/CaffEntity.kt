package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CaffEntity(
    val title: String,

    @OneToOne
    val creator: UserEntity,

    @ElementCollection
    val keywords: List<String>,

    @OneToMany
    val comments: MutableList<CommentEntity>,

    val base64Caff: String,

    val base64Preview: String,
) {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
}

