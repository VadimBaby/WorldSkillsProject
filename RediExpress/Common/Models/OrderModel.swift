//
//  OrderModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import Foundation

struct OrderModel: Codable {
    let package: PackageModel
    let destinations: [DestinationModel]
    let status: [StatusModel]
}
