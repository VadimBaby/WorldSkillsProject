//
//  TransactionModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 16.02.2024.
//

import Foundation

struct TransactionModel: Codable {
    let id: String
    let created_at: Date
    let charges: Int
    let instant: Int
    let tax_and_services_charges: Int
    let total: Int
    let package_id: String
}

