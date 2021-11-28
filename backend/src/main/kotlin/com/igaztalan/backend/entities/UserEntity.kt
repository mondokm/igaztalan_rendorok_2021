package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class UserEntity(
    val name: String,

    val password: String,

    @ManyToMany(fetch = FetchType.EAGER)
    val roles: List<RoleEntity>,

    @OneToMany(cascade = [CascadeType.ALL], orphanRemoval = true, mappedBy = "creator")
    val caffs: MutableList<CaffEntity>,

    @OneToMany(cascade = [CascadeType.ALL], orphanRemoval = true, mappedBy = "author")
    val comments: MutableList<CommentEntity>
){
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
}