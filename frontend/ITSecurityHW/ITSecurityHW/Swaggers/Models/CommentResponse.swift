//
// CommentResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommentResponse: Codable {

    public var _id: Int
    public var caffId: Int
    public var author: Author?
    public var message: String
    public var timestamp: Double

    public init(_id: Int, caffId: Int, author: Author?, message: String, timestamp: Double) {
        self._id = _id
        self.caffId = caffId
        self.author = author
        self.message = message
        self.timestamp = timestamp
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case caffId
        case author
        case message
        case timestamp
    }


}

