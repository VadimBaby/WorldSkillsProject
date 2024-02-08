//
//  MainTextFieldStyle.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct MainTextFieldStyle: TextFieldStyle {
    
    let isError: Bool
    
    init(isError: Bool = false) {
        self.isError = isError
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.leading, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isError ? Color.error : Color.customSecondaryText, lineWidth: 1)
            }
            .foregroundStyle(isError ? Color.error : Color.primary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

#Preview {
    TextField("placeholder", text: .constant(""))
        .textFieldStyle(MainTextFieldStyle(isError: true))
        .padding()
}
