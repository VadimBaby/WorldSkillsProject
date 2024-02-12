//
//  NetworkMonitor.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 11.02.2024.
//

import Foundation
import Network

final class NetworkMonitor {
    @Published var isConnected: Bool = false
    
    private let networkManager: NWPathMonitor = .init()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    init() {
        networkManager.pathUpdateHandler = { path in
            let isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.isConnected = isConnected
                }
            }
        }
        networkManager.start(queue: queue)
    }
}
