//
//  String.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import Foundation

extension String {
    func validateEmail() -> Bool {
//        let emailRegex = #"^[a-z0-9]+@[a-z0-9]+\.[a-z]{2,}$"#
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        
//        return emailPredicate.evaluate(with: self)
        
        return true
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
