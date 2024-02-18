//
//  PackageModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import Foundation

struct DestinationModel: Codable {
    let id: UUID
    let address: String
    let state_country: String
    let phone_number: String
    let others: String?
    let package_id: String
    let customer_id: UUID
    let created_at: Date
}

struct PackageModel: Codable {
    let id: String
    let created_at: Date
    let origin_address: String
    let origin_state_country: String
    let origin_phone_number: String
    let origin_others: String?
    let package_item: String
    let weight_of_item: String
    let worth_of_items: String
    var customer_id: UUID
    let is_active: Bool
    
    func changeCustomer(customerId: UUID) -> PackageModel {
        return PackageModel(id: id, created_at: created_at, origin_address: origin_address, origin_state_country: origin_state_country, origin_phone_number: origin_phone_number, origin_others: origin_others, package_item: package_item, weight_of_item: weight_of_item, worth_of_items: worth_of_items, customer_id: customerId, is_active: is_active)
    }
}
