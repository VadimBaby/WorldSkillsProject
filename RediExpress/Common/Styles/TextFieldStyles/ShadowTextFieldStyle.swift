//
//  ShadowTextFieldStyle.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct ShadowTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .robotoFont(size: 12, weight: .regular)
            .padding(.leading, 8)
            .background {
                Color.white
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0.0, y: 5)
            }
            .autocorrectionDisabled()
    }
}

#Preview {
    TextField("placeholder", text: .constant(""))
        .textFieldStyle(ShadowTextFieldStyle())
        .padding()
}
