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
    let customer_id: UUID
    
    func setNewUserID(customer: UUID) -> TransactionModel {
        return TransactionModel(id: id, created_at: created_at, charges: charges, instant: instant, tax_and_services_charges: tax_and_services_charges, total: total, package_id: package_id, customer_id: customer)
    }
}

