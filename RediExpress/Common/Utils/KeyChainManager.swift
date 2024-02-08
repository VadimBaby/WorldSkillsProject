//
//  KeyChainManager.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import Foundation
import CryptoKit

// класс для работы с Keychain
final class KeyChainManager {
    static let instance = KeyChainManager()
    
    // сохранение пароля в Keychain с использованием SHA512
    func savePassword(password: String) {
        guard let passwordData = password.data(using: .utf8) else {
            print("coding error")
            return
        }
        
        let passwordSHA512 = SHA512.hash(data: passwordData)
        
        let passwordString = passwordSHA512.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        guard let newPasswordData = passwordString.data(using: .utf8) else { print("coding error 2"); return }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: newPasswordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("success save")
        }
    }
}
