//
//  StatusMode;.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import Foundation

struct StatusModel: Codable {
    let id: String
    let created_at: Date
    let status: String
    let package_id: String
}
