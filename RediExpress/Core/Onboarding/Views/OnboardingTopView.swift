//
//  Компонент OnboardingTopView, используется как верхняя секция в OnboardingView
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import SwiftUI

struct OnboardingTopView: View {
    
    let image: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 346, height: 346)
            VStack(spacing: 10) {
                Text(title)
                    .robotoFont(size: 24)
                    .foregroundStyle(Color.customPrimary)
                    .bold()
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .robotoFont(size: 16)
                    .foregroundStyle(Color.customText)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 346)
        }
    }
}

#Preview {
    OnboardingTopView(image: "QuickDelivery", title: "Quick Delivery At You\nDoorstep", subtitle: "Enjoy quick pick-up and delivery to\nyour destination")
}
