//
//  AddPaymentView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct AddPaymentView: View {
    @State private var isCreditCard: Bool = false
    
    @State private var isFirst: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(
                    Color.white
                )
                .shadow(radius: 5, y: 3)
                .frame(height: 84)
                .overlay {
                    HStack {
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 1)
                            .frame(width: 12, height: 12)
                            .overlay {
                                if !isCreditCard {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 9, height: 9)
                                }
                            }
                            
                        VStack(alignment: .leading) {
                            Text("Play with wallet")
                                .foregroundStyle(Color.customBlack)
                                .robotoFont(size: 16)
                            Text("complete the payment using your e wallet")
                                .robotoFont(size: 12)
                                .foregroundStyle(Color.customSecondaryText)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .onTapGesture {
                    isCreditCard = false
                }
            
            
            
            Rectangle()
                .fill(
                    Color.white
                )
                .shadow(radius: 5, y: 3)
                .frame(height: isCreditCard ? 233 : 83)
                .overlay {
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 1)
                                .frame(width: 12, height: 12)
                                .overlay {
                                    if isCreditCard {
                                        Circle()
                                            .fill(Color.accentColor)
                                            .frame(width: 9, height: 9)
                                    }
                                }
                                
                            VStack(alignment: .leading) {
                                Text("Credit/ debit card")
                                    .foregroundStyle(Color.customBlack)
                                    .robotoFont(size: 16)
                                Text("complete the payment using your debit card")
                                    .robotoFont(size: 12)
                                    .foregroundStyle(Color.customSecondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if isCreditCard {
                            VStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .shadow(radius: 5, y: 3)
                                    .frame(height: 68)
                                    .overlay {
                                        HStack {
                                            Circle()
                                                .stroke(Color.accentColor, lineWidth: 1)
                                                .frame(width: 12, height: 12)
                                                .overlay {
                                                    if isFirst {
                                                        Circle()
                                                            .fill(Color.accentColor)
                                                            .frame(width: 9, height: 9)
                                                    }
                                                }
                                            Text("**** **** 3323")
                                                .robotoFont(size: 16)
                                                .foregroundStyle(Color.customBlack)
                                            Spacer()
                                            Image("trash")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 15, height: 15)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .onTapGesture {
                                        self.isFirst = true
                                    }
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .shadow(radius: 5, y: 3)
                                    .frame(height: 68)
                                    .overlay {
                                        HStack {
                                            Circle()
                                                .stroke(Color.accentColor, lineWidth: 1)
                                                .frame(width: 12, height: 12)
                                                .overlay {
                                                    if !isFirst {
                                                        Circle()
                                                            .fill(Color.accentColor)
                                                            .frame(width: 9, height: 9)
                                                    }
                                                }
                                            Text("**** **** 3323")
                                                .robotoFont(size: 16)
                                                .foregroundStyle(Color.customBlack)
                                            Spacer()
                                            Image("trash")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 15, height: 15)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .onTapGesture {
                                        self.isFirst = false
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
                .onTapGesture {
                    isCreditCard = true
                }
            Spacer()
            Button("Proceed To Pay") {
                
            }
            .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
        }
        .padding(.bottom, 55)
        .padding(.top, 67)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 24)
        .navigationBarHidden(true)
        .addNavigationTitle(title: "Add Payment method") {
            dismiss()
        }
    }
}

#Preview {
    AddPaymentView()
}
