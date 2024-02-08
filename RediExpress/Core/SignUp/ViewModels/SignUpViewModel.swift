//
//  ViewModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import Foundation

extension SignUpView {
    final class ViewModel: ObservableObject {
        
        func signUp (
            name: String,
            phone: String,
            email: String,
            password: String
        ) async -> Bool {
            do {
                try await SupabaseManager.instance.signUp(name: name, phone: phone, email: email, password: password)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
    }
}
