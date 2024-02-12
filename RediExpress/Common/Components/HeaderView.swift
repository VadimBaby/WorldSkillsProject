//
//  HeaderView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let dismiss: (() -> Void)?
    
    init(title: String, dismiss: (() -> Void)? = nil) {
        self.title = title
        self.dismiss = dismiss
    }
    
    var body: some View {
        HStack {
            Text(title)
                .robotoFont(size: 16, weight: .medium)
                .foregroundStyle(Color.customSecondaryText)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if let dismiss {
                        Button(action: {
                            dismiss()
                        }, label: {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .overlay {
                                    Image(systemName: "chevron.left")
                                        .foregroundStyle(Color.accentColor)
                                        .font(.system(size: 12, weight: .bold))
                                }
                        })
                        .padding(.leading)
                    }
                }
        }
        .frame(height: 55)
        .background {
            GeometryReader { geo in
                Color.white
                    .shadow(color: .black, radius: 15, x: 0, y: -20)
                    .mask(Rectangle().padding(.bottom, -20))
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ForEach(0...100, id: \.self) { _ in
                Rectangle()
                    .frame(height: 50)
            }
        }
    }
    .addNavigationTitle(title: "Title") {
        
    }
}
