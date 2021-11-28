//
//  AppData.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 24..
//

final class AppData {
    static let shared = AppData()
    private init() { }

    @Storage(key: .token) var token: String?
    @Storage(key: .id) var id: Int?
}
