//
//  PackageModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import Foundation

struct PackageModel: Codable {
    let id: String
    let created_at: Date
    let origin_address: String
    let origin_state_country: String
    let origin_phonenumber: String
    let origin_others: String?
    let destination_address: String
    let destination_state_country: String
    let destination_phonenumber: String
    let destination_others: String?
    let destination2_address: String?
    let destination2_state_country: String?
    let destination2_phonenumber: String?
    let destination2_others: String?
    let package_item: String
    let weight_of_item: String
    let worth_of_items: String
    var customer_id: UUID
    
    func changeCustomer(customerId: UUID) -> PackageModel {
        return PackageModel(id: id, created_at: created_at, origin_address: origin_address, origin_state_country: origin_state_country, origin_phonenumber: origin_phonenumber, origin_others: origin_others, destination_address: destination_address, destination_state_country: destination_state_country, destination_phonenumber: destination_phonenumber, destination_others: destination_others, destination2_address: destination2_address, destination2_state_country: destination2_state_country, destination2_phonenumber: destination2_phonenumber, destination2_others: destination2_others, package_item: package_item, weight_of_item: weight_of_item, worth_of_items: worth_of_items, customer_id: customerId)
    }
}
