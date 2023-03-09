//
//  DalleImageGenerate.swift
//  MyDalle
//
//  Created by Илья Дубенский on 09.03.2023.
//

/* Moderation Endpoint
 curl https://api.openai.com/v1/moderations \
 -X POST \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer $OPENAI_API_KEY" \
 -d '{"input": "Sample text goes here"}'
 */

/* Moderation Parameters
 {
 "input": "A cute baby sea otter",
 }
 */

/* Generations Parameters
 {
 "prompt": "A cute baby sea otter",
 "n": 2,
 "size": "1024x1024"
 }
 */

import SwiftUI

enum URLS: String {
    case openAIModerations = "https://api.openai.com/v1/moderations"
    case openAIGenerations = "https://api.openai.com/v1/images/generations"
}

enum ImageError: Error {
    case inInvalidPrompt
    case badUrl
}

class DalleImageGenerate {

    static let shared: DalleImageGenerate = .init()

    let sessionID = UUID().uuidString

    func makeSurePromptIsValid(_ prompt: String, apiKey: String) async throws -> Bool {
        guard let url = URL(string: URLS.openAIModerations.rawValue) else { throw ImageError.badUrl }
        
        let parameters: [String: Any] = ["input": prompt]
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data

        let (response, _) = try await URLSession.shared.data(for: urlRequest)
        let result = try JSONDecoder().decode(ModerationResponse.self, from: response)

        return result.hasIssues == false
    }

    func generateImage(withPrompt prompt: String, apiKey: String) async throws -> ImageGenerationResponse {
        guard try await makeSurePromptIsValid(prompt, apiKey: apiKey) else { throw ImageError.inInvalidPrompt }

        guard let url = URL(string: URLS.openAIGenerations.rawValue) else { throw ImageError.badUrl }

        let parameters: [String: Any] = ["prompt": prompt,
                                         "n": 1,
                                         "size": "1024x1024",
                                         "user": sessionID]

        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data

        let (response, _) = try await URLSession.shared.data(for: urlRequest)
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)

        return result
    }
}
