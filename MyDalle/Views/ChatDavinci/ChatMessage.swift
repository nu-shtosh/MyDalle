//
//  ChatMessage.swift
//  MyDalle
//
//  Created by Илья Дубенский on 10.03.2023.
//

import Foundation

enum MessageSender {
    case me
    case gpt
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}
