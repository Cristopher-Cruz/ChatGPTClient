//
//  APIModels.swift
//
//
//  Created by christopher cruz on 5/4/23.
//

import Foundation

struct Message: Codable {
    let role: String
    let content: String
}

extension Array where Element == Message {
    
    var contentCount: Int { reduce(0, { $0 + $1.content.count })}
}

struct Request: Codable {
    let model: String
    let temperature: Double
    let messages: [Message]
    let stream: Bool
}

struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}


// For giving back the user message : in one go *NOT A STREAM*
struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Choice: Decodable {
    let message: Message
    let finishReason: String?
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}


// For giving back the api response message : in a stream
struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}

struct StreamChoice: Decodable {
    let delta: StreamMessage
    let finishReason: String?
}

struct StreamMessage: Decodable {
    let role: String?
    let content: String?
}

