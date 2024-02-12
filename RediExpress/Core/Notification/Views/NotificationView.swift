//
//  NotificationView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct NotificationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("notification.black")
                .resizable()
                .frame(width: 83, height: 83)
            Text("You have no notifications")
                .robotoFont(size: 16, weight: .medium)
            Spacer()
        }
        .padding(.top, 120)
        .addNavigationTitle(title: "Notification") {
            dismiss()
        }
    }
}

#Preview {
    NotificationView()
}
