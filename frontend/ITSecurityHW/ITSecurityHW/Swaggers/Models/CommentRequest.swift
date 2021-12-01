//
// CommentRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommentRequest: Codable {

    public var caffId: Int
    public var authorId: Int
    public var message: String
    public var timestamp: Double

    public init(caffId: Int, authorId: Int, message: String, timestamp: Double) {
        self.caffId = caffId
        self.authorId = authorId
        self.message = message
        self.timestamp = timestamp
    }


}
