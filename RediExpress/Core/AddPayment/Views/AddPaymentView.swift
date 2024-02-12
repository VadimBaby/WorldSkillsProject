//
//  AddPaymentView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct AddPaymentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
        }
        .navigationBarHidden(true)
        .addNavigationTitle(title: "Add Payment method") {
            dismiss()
        }
    }
}

#Preview {
    AddPaymentView()
}
