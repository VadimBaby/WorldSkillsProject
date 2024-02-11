//
//  CustomTextField.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct CustomTextField: View {
    
    let label: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let isError: Bool
    
    @State private var showTextField: Bool = false
    
    init(label: String, placeholder: String, text: Binding<String>, isSecure: Bool = false, isError: Bool = false) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.isError = isError
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .robotoFont(size: 14, weight: .medium)
                .foregroundStyle(Color.customSecondaryText)
            
            Group {
                if !isSecure {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(MainTextFieldStyle(isError: isError))
                } else {
                    ZStack(alignment: .trailing) {
                        Group {
                            if showTextField {
                                TextField(placeholder, text: $text)
                                    .textFieldStyle(MainTextFieldStyle(isError: isError))
                            } else {
                                SecureField(placeholder, text: $text)
                                    .textFieldStyle(MainTextFieldStyle(isError: isError))
                            }
                        }
                        
                        Button(action: {
                            self.showTextField.toggle()
                        }, label: {
                            Image(systemName: showTextField ? "eye" : "eye.slash")
                                // .bold()
                        })
                        .tint(Color.customBlack)
                        .padding(.trailing, 11)
                    }
                }
            }
        }
    }
}

#Preview {
    CustomTextField(label: "Label", placeholder: "Placholder", text: .constant("text"), isSecure: true, isError: true)
        .padding()
}
