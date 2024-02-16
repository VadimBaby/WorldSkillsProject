//
//  UUID.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 16.02.2024.
//

import Foundation


extension UUID {
    func returnTrack() -> String {
        let uuid = self.uuid
        
        let formattedString = String(format: "%02X%02X-%02X%02X-%02X%02X-%02X%02X", uuid.0, uuid.1, uuid.2, uuid.3, uuid.4, uuid.5, uuid.6, uuid.7, uuid.8, uuid.9, uuid.10, uuid.11, uuid.12, uuid.13, uuid.14, uuid.15)

        
        return "R-\(formattedString)"
    }
}

/*
 
 extension UUID {
     func returnTrack() -> String {
         let uuidString = self.uuidString.replacingOccurrences(of: "-", with: "")
         let formattedString = "\(uuidString.prefix(4))-\(uuidString.prefix(8).suffix(4))-\(uuidString.prefix(12).suffix(4))-\(uuidString.suffix(4))"
         
         return "R-\(formattedString)"
     }
     
     func returnTrack2() -> String {
         let tuple = self.uuid

         let formattedString = String(format: "%02X%02X-%02X%02X-%02X%02X-%02X%02X", tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7, tuple.8, tuple.9, tuple.10, tuple.11, tuple.12, tuple.13, tuple.14, tuple.15)

         
         return "R-\(formattedString)"
     }
 } 
 
 */
