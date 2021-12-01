package com.igaztalan.backend

import org.passay.*
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder

@Configuration
class Configuration {

    @Bean
    fun passwordEncoder() = BCryptPasswordEncoder()

    @Bean
    fun validator() = PasswordValidator(
        listOf(
            LengthRule().apply { this.minimumLength = 8 },
            CharacterRule(EnglishCharacterData.UpperCase, 1),
            CharacterRule(EnglishCharacterData.LowerCase, 1),
            CharacterRule(EnglishCharacterData.Digit, 1),
            CharacterRule(EnglishCharacterData.Special, 1),
            WhitespaceRule(),
            IllegalSequenceRule(EnglishSequenceData.Alphabetical, 5, false),
            IllegalSequenceRule(EnglishSequenceData.Numerical, 5, false)
        )
    )

}