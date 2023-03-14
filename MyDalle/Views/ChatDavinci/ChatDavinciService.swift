//
//  ChatAIService.swift
//  MyDalle
//
//  Created by Илья Дубенский on 11.03.2023.
//

import Foundation
import Alamofire
import Combine

class ChatDavinciService {
    func sendMessage(message: String, apiKey: String) -> AnyPublisher<ChatAICompletionsResponse, Error>  {
        let body = ChatAICompletionsBody(model: ChatAIModel.davinci.rawValue,
                                     prompt: message,
                                     temperature: 0.7,
                                     max_tokens: 256)

        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(apiKey)"
        ]

        return Future { [weak self] promise in
            guard self != nil else { return }
            AF.request(URLS.openAICompletions.rawValue,
                       method: .post,
                       parameters: body,
                       encoder: .json,
                       headers: headers).responseDecodable(of: ChatAICompletionsResponse.self) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
