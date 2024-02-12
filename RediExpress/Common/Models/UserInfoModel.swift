//
//  UserInfoModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import Foundation

struct UserInfoModel: Codable {
    let id: UUID
    let created_at: Date
    let balance: Double
}
