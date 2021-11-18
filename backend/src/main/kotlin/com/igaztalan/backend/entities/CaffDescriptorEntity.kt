package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CaffDescriptorEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    var name: String,

    @OneToOne
    var creator: UserEntity,

    @ElementCollection
    var keywords: List<String>,

    @OneToMany
    var comments: List<CommentEntity>,
)

