//
//  Стиль кнопки PrimaryButtonStyle
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    let width: CGFloat?
    let maxWidth: CGFloat?
    let disabled: Bool
    
    init(width: CGFloat, disabled: Bool = false) {
        self.width = width
        self.maxWidth = nil
        self.disabled = disabled
    }
    
    init(maxWidth: CGFloat, disabled: Bool = false) {
        self.maxWidth = maxWidth
        self.width = nil
        self.disabled = disabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: 50)
            .frame(maxWidth: maxWidth)
            .foregroundStyle(Color.white)
            .robotoFont(size: 14)
            .bold()
            .background(disabled ? Color.customSecondaryText : Color.customPrimary.opacity(configuration.isPressed ? 0.2 : 1))
            .clipShape(.rect(cornerRadius: 5))
    }
}

#Preview {
    Button("Button") {
        
    }
    .buttonStyle(PrimaryButtonStyle(width: 300))
    .padding()
}
