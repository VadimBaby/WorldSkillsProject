//
//  MessageModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import Foundation

struct MessageModel: Codable {
    let id: UUID
    let created_at: Date
    let message: String
    let sender_id: UUID
    let recipient_id: UUID
}
