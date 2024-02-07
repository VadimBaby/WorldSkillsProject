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
            .foregroundStyle(Color.white)
            .robotoFont(size: 14)
            .bold()
            .background(Color.customPrimary.opacity(configuration.isPressed ? 0.2 : 1))
            .clipShape(.rect(cornerRadius: 5))
    }
}

#Preview {
    Button("Button") {
        
    }
    .buttonStyle(PrimaryButtonStyle(width: 300))
    .padding()
}
