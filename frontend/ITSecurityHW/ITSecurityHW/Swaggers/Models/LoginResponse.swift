//
// LoginResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct LoginResponse: Codable {

    public var token: String
    public var isAdmin: Int
    public var userId: Int

    public init(token: String, isAdmin: Int, userId: Int) {
        self.token = token
        self.isAdmin = isAdmin
        self.userId = userId
    }


}

