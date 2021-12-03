package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class CommentEntity (
    @ManyToOne(cascade = [CascadeType.REFRESH])
    @JoinColumn
    val author: UserEntity,

    val message: String,

    val timestamp: Long,

    @ManyToOne(cascade = [CascadeType.REFRESH])
    @JoinColumn
    val caff: CaffEntity
) {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
}
