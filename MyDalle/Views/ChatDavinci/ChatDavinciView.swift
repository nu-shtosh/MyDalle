//
//  ChatAI.swift
//  MyDalle
//
//  Created by Илья Дубенский on 10.03.2023.
//

import SwiftUI
import Combine

struct ChatDavinciView: View {

    @State private var chatMessages: [ChatMessage] = []
    @State private var messageText = ""

    @State private var cancellables = Set<AnyCancellable>()

    let chatAIService = ChatDavinciService()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { message in
                            messageView(message: message)
                        }
                    }
                }
                HStack {
                    TextField("Enter a message...", text: $messageText, axis: .vertical)
                        .padding(10)
                        .background(.blue.opacity(0.1))
                        .font(Font.system(size: 16, weight: .medium, design: .monospaced))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.8), lineWidth: 1))
                        .cornerRadius(10)
                    Button(action: sendMessage) {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(messageText == "" ? .gray.opacity(0.8) : .blue.opacity(0.8))
                            .cornerRadius(10)
                            .font(Font.system(size: 16, weight: .medium, design: .serif))
                    }
                    .disabled(messageText == "")
                    .animation(.default, value: messageText == "")
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
            .navigationTitle("Chat With AI")
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .animation(.default, value: messageText == "")

        }
    }

    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .padding()
                .foregroundColor(.white)
                .background(message.sender == .me ? .blue.opacity(0.8) : .indigo.opacity(0.8))
                .cornerRadius(10)
                .font(Font.system(size: 16, weight: .medium, design: message.sender == .me ? .serif : .monospaced))
                .textSelection(.enabled)
                .lineLimit(100)
            if message.sender == .gpt { Spacer() }
        }
    }

    func sendMessage() {
        print("Send Message Button Did Tapped.")

        let myMessage = ChatMessage(id: UUID().uuidString,
                                    content: messageText,
                                    dateCreated: Date(),
                                    sender: .me)
        chatMessages.append(myMessage)

        chatAIService.sendMessage(message: messageText,
                                         apiKey: Secrets.openAIApiKey).sink { completion in
            // Handler Error
        } receiveValue: { response in
            print(response.choices)
            guard let textResponse = response.choices.first?.text.trimmingCharacters(
                in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let gptMessage = ChatMessage(id: response.id,
                                         content: textResponse,
                                         dateCreated: Date(),
                                         sender: .gpt)
            chatMessages.append(gptMessage)
        }.store(in: &cancellables)

        messageText = ""

    }
}

struct ChatDavinciView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDavinciView()
    }
}
