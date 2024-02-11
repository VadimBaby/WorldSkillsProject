//
//  Стиль кнопки SecondaryButtonStyle
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    
    let width: CGFloat?
    let maxWidth: CGFloat?
    
    init(width: CGFloat) {
        self.width = width
        self.maxWidth = nil
    }
    
    init(maxWidth: CGFloat) {
        self.maxWidth = maxWidth
        self.width = nil
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: 50)
            .frame(maxWidth: maxWidth)
            .foregroundStyle(Color.customPrimary.opacity(configuration.isPressed ? 0.2 : 1))
            .robotoFont(size: 14, weight: .medium)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.customPrimary.opacity(configuration.isPressed ? 0.2 : 1), lineWidth: 1)
            }
    }
}

#Preview {
    Button("Button") {
        
    }
    .buttonStyle(SecondaryButtonStyle(maxWidth: .infinity))
    .padding()
}
