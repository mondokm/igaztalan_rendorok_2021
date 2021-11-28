package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CaffEntity(
    val title: String,

    @ManyToOne(cascade = [CascadeType.REFRESH])
    @JoinColumn
    val creator: UserEntity,

    @ElementCollection
    val keywords: List<String>,

    @OneToMany(cascade = [CascadeType.ALL], orphanRemoval = true, mappedBy = "caff")
    val comments: MutableList<CommentEntity>,
) {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
}

