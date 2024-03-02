//
//  LiveMessagesService.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import Foundation
import Realtime

final class LiveMessagesService {
    @Published var message: MessageModel? = nil
    @Published var userID: UUID? = nil
    
    static let instance = LiveMessagesService()
    
    init() {
        subscribe()
    }
    
    private func subscribe() {
        Task {
            do {
                let user = try await SupabaseManager.instance.GetUserId()
                await MainActor.run {
                    self.userID = user
                }
                
                let channel = await SupabaseManager.instance.getAllMessagesChannel()
                
                Task {
                    for await status in await channel.statusChange {
                        print(status)
                    }
                }
                
                Task {
                    do {
                        let userId = try await SupabaseManager.instance.GetUserId()
                        print("subsribe")
                        for await update in await channel.postgresChange(InsertAction.self, schema: "public", table: "messages") {
                            struct DecodeUpdate: Codable {
                                let id: UUID
                                let created_at: String
                                let message: String
                                let sender_id: UUID
                                let recipient_id: UUID
                            }
                            
                            print("update")
                            
                            do {
                                let data = try update.decodeRecord(as: DecodeUpdate.self, decoder: JSONDecoder())
                                
                                let message = MessageModel(id: data.id, created_at: .now, message: data.message, sender_id: data.sender_id, recipient_id: data.recipient_id)
                                
                                await MainActor.run {
                                    self.message = message
                                }
                            } catch {
                                print("BIG ERROR: " + error.localizedDescription)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                await channel.subscribe()
            }
        }
    }
}
