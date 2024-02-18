//
//  FeedbackModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import Foundation

struct FeedbackModel: Codable {
    let id: String
    let created_at: Date
    let package_id: String
    let customer_id: UUID
    let rate: Int
    let feedback: String
}
