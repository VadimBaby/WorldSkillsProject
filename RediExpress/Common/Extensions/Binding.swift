//
//  Binding.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {
    init(error: Binding<String?>) {
        self.init {
            return error.wrappedValue != nil
        } set: { newValue in
            error.wrappedValue = newValue ? "" : nil
        }
    }
}
