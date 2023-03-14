//
//  Secrets.swift
//  MyDalle
//
//  Created by Илья Дубенский on 10.03.2023.
//

import Foundation


enum URLS: String {
    case openAIModerations = "https://api.openai.com/v1/moderations"
    case openAIGenerations = "https://api.openai.com/v1/images/generations"
    case openAICompletions = "https://api.openai.com/v1/completions"
}

enum ImageError: Error {
    case inInvalidPrompt
    case badUrl
}

enum ChatError: Error {
    case badUrl
}

enum ChatAIModel: String {
    case davinci = "text-davinci-003"
    case turbo = "gpt-3.5-turbo-0301"
}
