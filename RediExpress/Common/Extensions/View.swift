//
//  Расширения для View

//  Created by Вадим Мартыненко on 07.02.2024.
//

import Foundation
import SwiftUI

extension View {
    // Применяет шрифт Roboto с заданным размером
    func robotoFont(size: CGFloat) -> some View {
        self
            .font(.custom("Roboto", size: size))
    }
}
