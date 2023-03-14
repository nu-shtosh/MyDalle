//
//  ChatAICompletions.swift
//  MyDalle
//
//  Created by Илья Дубенский on 11.03.2023.
//

import Foundation

struct ChatAICompletionsBody: Codable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int?
}

