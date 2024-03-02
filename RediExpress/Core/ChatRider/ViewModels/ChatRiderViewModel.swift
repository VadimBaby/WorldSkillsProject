//
//  ChatRiderViewModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import Foundation
import Combine
import Realtime

struct MessageChatModel {
    let message: MessageModel
    let myMessage: Bool
}

extension ChatRiderView {
    final class ViewModel: ObservableObject {
        @Published var messages: [MessageChatModel]? = nil
        
        private let to: UUID
        
        private var cancellables: Set<AnyCancellable> = .init()
        
        init(person: UUID) {
            self.to = person
            getMessages(person: person)
            subscribeToMessages()
        }
        
        func sendMessage(message: String) {
            Task {
                do {
                    try await SupabaseManager.instance.sendMessage(message: message, to: to)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        private func subscribeToMessages() {
            LiveMessagesService.instance.$message
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if let data, let userId = LiveMessagesService.instance.userID {
                        let newMessage = MessageChatModel(message: .init(id: data.id, created_at: .now, message: data.message, sender_id: data.sender_id, recipient_id: data.recipient_id), myMessage: data.sender_id == userId)
                        
                        self?.messages?.append(newMessage)
                        self?.sortedMessage()
                    }
                }
                .store(in: &cancellables)
        }
        
        private func getMessages(person: UUID) {
            Task {
                do {
                    let messages = try await SupabaseManager.instance.getAllMessages(person: person)
                    await MainActor.run {
                        self.messages = messages.sorted(by: {$0.message.created_at < $1.message.created_at})
                    }
                } catch {
                    print(error.localizedDescription)
                    await MainActor.run {
                        self.messages = []
                    }
                }
            }
        }
        
        private func sortedMessage() {
            if let messages = self.messages {
                self.messages = messages.sorted(by: {$0.message.created_at < $1.message.created_at})
            }
        }
    }
}
