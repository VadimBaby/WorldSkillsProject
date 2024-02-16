//
//  RediExpressApp.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import SwiftUI

@main
struct RediExpressApp: App {
    @State private var isLogin: Bool? = nil
    
    let watchedQueueItemId: String?
    
    init() {
        let watchedQueueItemId = UserDefaults.standard.string(forKey: UserDefaultsKeys.watchedQueueItemId)
        
        self.watchedQueueItemId = watchedQueueItemId
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if let isLogin {
                    if isLogin {
                        Group {
                            HomeView()
                        }
                        .addNavigationStack()
                    } else {
                        Group {
                            if let last = Constants.queue.last,
                               watchedQueueItemId != last.id {
                                OnboardingView(watchedQueueItemId: watchedQueueItemId)
                            } else {
                                HolderView()
                            }
                        }
                        .addNavigationStack()
                    }
                } else {
                    ProgressView()
                }
            }
            .task {
                let isLogin = await SupabaseManager.instance.isLogIn()
                
                await MainActor.run {
                    self.isLogin = isLogin
                }
            }
        }
    }
}
