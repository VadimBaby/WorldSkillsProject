//
//  CheckBox.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct CheckBox: View {
    
    @Binding var value: Bool
    
    var body: some View {
        Group {
            if value {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.customBlue)
                    .frame(width: 14, height: 14)
                    .overlay {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 6, height: 6)
                            .foregroundStyle(Color.white)
                            //  .bold()
                    }
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.customBlue, lineWidth: 1)
                    .frame(width: 14, height: 14)
            }
        }
        .onTapGesture {
            self.value.toggle()
        }
    }
}

#Preview {
    CheckBox(value: .constant(true))
}
