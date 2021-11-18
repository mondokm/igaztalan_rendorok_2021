package com.igaztalan.backend.entities

import javax.persistence.*

@Entity
class UserEntity(
    val name: String,

    val password: String,

    @ManyToMany(fetch = FetchType.EAGER)
    val roles: List<RoleEntity>
){
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0
}