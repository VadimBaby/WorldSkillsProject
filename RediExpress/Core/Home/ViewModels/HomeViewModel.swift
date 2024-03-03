//
//  HomeViewModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 03.03.2024.
//

import Foundation
import SwiftUI
import Combine

extension RealHomeView {
    final class ViewModel: ObservableObject {
        @Published var avatar: Data? = nil
        @Published var name: String = ""
        
        @Published var image: UIImage? = nil
        
        private var cancellables: Set<AnyCancellable> = .init()
        
        init() {
            getName()
            downloadAvatar()
            
            subscribers()
        }
        
        private func subscribers() {
            $image
                .sink { [weak self] image in
                    guard let image, let data = image.jpegData(compressionQuality: 1.0), let self = self else { return }
                    print("upload avatar")
                    uploadAvatar(avatar: data)
                }
                .store(in: &cancellables)
        }
        
        private func uploadAvatar(avatar: Data) {
            Task {
                do {
                    try await SupabaseManager.instance.uploadAvatar(avatar: avatar)
                } catch {
                    print("Avatar Erro: " + error.localizedDescription)
                }
            }
        }
        
        private func getName() {
            Task {
                do {
                    let user = try await SupabaseManager.instance.getUser()
                    await MainActor.run {
                        self.name = user.name
                    }
                } catch {
                    await MainActor.run {
                        self.name = "ERROR"
                    }
                    print(error.localizedDescription)
                }
            }
        }
        
        private func downloadAvatar() {
            Task {
                do {
                    let data = try await SupabaseManager.instance.fetchMyAvatar()
                    await MainActor.run {
                        self.avatar = data
                    }
                } catch {
                    await MainActor.run {
                        self.avatar = Data()
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
}
