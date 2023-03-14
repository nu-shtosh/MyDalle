//
//  ChatAICompletionsResponse.swift
//  MyDalle
//
//  Created by Илья Дубенский on 11.03.2023.
//

import Foundation

struct ChatAICompletionsResponse: Codable {
    let id: String
    let choices: [ChatAICompletionsChoices]
}

struct ChatAICompletionsChoices: Codable {
    let text: String
}
