//
//  ChatService.swift
//  DriveAware
//
//  Created by Alexander Ur on 1/19/26.
//

import Foundation

class ChatService {
    private var apiKey: String {
        return "API_KEY"
    }
    private let endpoint = "https://api.openai.com/v1/chat/completions"

    func getResponse(messages: [Message]) async throws -> String {
        guard let url = URL(string: endpoint) else { throw URLError(.badURL) }
        
        let apiMessages = messages.map { ["role": $0.role.rawValue, "content": $0.content] }
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": apiMessages
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(OpenAIResult.self, from: data)
        return result.choices.first?.message.content ?? "I'm not sure how to respond to that."
    }
}

struct OpenAIResult: Decodable {
    struct Choice: Decodable {
        struct MessageContent: Decodable {
            let content: String
        }
        let message: MessageContent
    }
    let choices: [Choice]
}
