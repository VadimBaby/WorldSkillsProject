//
//  RediExpressApp.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import SwiftUI

@main
struct RediExpressApp: App {
    let watchedQueueItemId: String?
    
    init() {
        let watchedQueueItemId = UserDefaults.standard.string(forKey: UserDefaultsKeys.watchedQueueItemId)
        
        self.watchedQueueItemId = watchedQueueItemId
    }
    
    var body: some Scene {
        WindowGroup {
            if let last = Constants.queue.last,
               watchedQueueItemId != last.id {
                OnboardingView(watchedQueueItemId: watchedQueueItemId)
            } else {
                HolderView()
            }
        }
    }
}
