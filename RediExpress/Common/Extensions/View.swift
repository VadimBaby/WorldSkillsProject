//
//  Расширения для View

//  Created by Вадим Мартыненко on 07.02.2024.
//

import Foundation
import SwiftUI

enum FontWeight {
    case bold, medium, regular
}

extension View {
    // Применяет шрифт Roboto с заданным размером
    @ViewBuilder func addNavigationDestination<T: View>(isPresented: Binding<Bool>, closure: () -> T) -> some View {
        if #available(iOS 16.0, *) {
            self
                .navigationDestination(isPresented: isPresented) {
                    closure()
                }
        } else {
            self
        }
    }
    
    func robotoFont(size: CGFloat, weight: FontWeight = .regular) -> some View {
        switch weight {
        case .bold:
            self
                .font(.custom("Roboto-Bold", size: size))
        case .medium:
            self
                .font(.custom("Roboto-Medium", size: size))
        case .regular:
            self
                .font(.custom("Roboto", size: size))
        }
    }
    
    @ViewBuilder func addNavigationStack() -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                self
            }
        } else {
            NavigationView {
                self
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
