package com.igaztalan.backend.security

object SecurityConstants {
    const val SECRET = "hatalmastitok"
    const val EXPIRATION_TIME: Long = 864000000 // 10 days

    const val TOKEN_PREFIX = "Bearer "
    const val HEADER_STRING = "Authorization"
    const val SIGN_UP_URL = "/user/sign-up"

    const val ROLE_ADMIN = "ROLE_ADMIN"
    const val ROLE_USER = "ROLE_USER"
}
