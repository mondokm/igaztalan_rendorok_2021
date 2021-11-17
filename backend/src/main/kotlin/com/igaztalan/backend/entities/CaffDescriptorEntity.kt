package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CaffDescriptorEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
    
    var name: String = ""

    @OneToOne
    var creator: UserEntity = UserEntity()

    @ElementCollection
    var keywords: List<String> = listOf()

    @OneToMany
    var comments: List<CommentEntity> = listOf()
}

