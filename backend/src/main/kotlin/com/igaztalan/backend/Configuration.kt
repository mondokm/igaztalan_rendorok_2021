package com.igaztalan.backend


import org.passay.CharacterRule
import org.passay.LengthRule
import org.passay.PasswordValidator
import org.passay.WhitespaceRule
import org.passay.IllegalSequenceRule
import org.passay.EnglishCharacterData
import org.passay.EnglishSequenceData
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

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
