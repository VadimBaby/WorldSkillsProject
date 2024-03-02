//
//  ChatViewModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import Foundation
import Combine
import Realtime

extension ChatsView {
    final class ViewModel: ObservableObject {
        
        @Published private(set) var users: [UserChatModel]? = nil
        @Published private(set) var filteredUsers: [UserChatModel] = []
        
        @Published var search: String = ""
        
        private var cancellables: Set<AnyCancellable> = .init()
        
        init() {
            request()
            
            subscribers()
            
            subscribeOnMessages()
        }
        
        deinit {
            cancellables.forEach{ $0.cancel() }
            cancellables = .init()
        }
        
        private func subscribers() {
            $search
                .sink { [weak self] value in
                    guard let self = self else { return }
                    
                    guard let users = self.users else { return }
                    
                    if value.isEmpty {
                        self.filteredUsers = users.sorted(by: {
                            
                            if let message1 = $0.message,
                               let message2 = $1.message {
                                return  message1.created_at > message2.created_at
                            }
                            
                            if $0.message != nil {
                                return false
                            }
                            
                            return true
                        })
                    } else {
                        let filtered = users.filter {
                            $0.user.name.contains(value)
                        }
                        
                        self.filteredUsers = filtered.sorted(by: {
                            
                            if let message1 = $0.message,
                               let message2 = $1.message {
                                return  message1.created_at > message2.created_at
                            }
                            
                           return true
                        })
                    }
                }
                .store(in: &cancellables)
            
            $users
                .sink { [weak self] newUsers in
                    guard let newUsers else { return }
                    
                    self?.filteredUsers = newUsers.sorted(by: {
                        
                        if let message1 = $0.message,
                           let message2 = $1.message {
                            return  message1.created_at > message2.created_at
                        }
                        
                        if $0.message == nil {
                            return false
                        }
                        
                       return true
                    })
                }
                .store(in: &cancellables)
        }
        
        private func request() {
            Task {
                do {
                    let users = try await SupabaseManager.instance.fetchUsers()
                    
                    await MainActor.run {
                        self.users = users
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        private func subscribeOnMessages() {
            LiveMessagesService.instance.$message
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] message in
                    if let userID = LiveMessagesService.instance.userID, let message {
                        if message.recipient_id == userID || message.sender_id == userID {
                            let senderid = message.recipient_id == userID ? message.sender_id : message.recipient_id
                            
                            let newUsers = self?.filteredUsers.map {
                                if $0.user.id == senderid {
                                    return UserChatModel(user: $0.user, message: message)
                                } else {
                                    return $0
                                }
                            }
                            
                            self?.users = newUsers
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
}
