//
//  SettingsKey.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 24..
//

enum SettingsKey: String {
    case token
    case id
    case isAdmin

    var keyName: String {
        rawValue
    }
}
