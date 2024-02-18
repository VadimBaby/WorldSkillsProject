//
//  ReceiptView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct ReceiptView: View {
    
    let originAddress: String
    let originCountry: String
    let originPhone: String
    let originOthers: String
    
    let sections: [SendPackageSection]
    
    let items: String
    let weight: String
    let worth: String
    let trackNumber: String
    
    let isTrack: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isNavigate: Bool = false
    @State private var isNavigateSuccessfull: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Package Information")
                    .robotoFont(size: 16, weight: .medium)
                    .foregroundStyle(Color.accentColor)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Origin Details")
                        .robotoFont(size: 12, weight: .regular)
                        .foregroundStyle(Color.customBlack)
                    Text(originAddress + ", " + originCountry)
                        .robotoFont(size: 12, weight: .regular)
                        .foregroundStyle(Color.customSecondaryText)
                    Text(originPhone)
                        .robotoFont(size: 12, weight: .regular)
                        .foregroundStyle(Color.customSecondaryText)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Destination Details")
                        .robotoFont(size: 12, weight: .regular)
                        .foregroundStyle(Color.customBlack)
                    ForEach(sections.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(index + 1). " + sections[index].address + ", " + sections[index].country)
                                .robotoFont(size: 12, weight: .regular)
                                .foregroundStyle(Color.customSecondaryText)
                            Text(sections[index].phone)
                                .robotoFont(size: 12, weight: .regular)
                                .foregroundStyle(Color.customSecondaryText)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Other Details")
                        .robotoFont(size: 12, weight: .regular)
                        .foregroundStyle(Color.customBlack)
                    HStack {
                        Text("Package Items")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text(items)
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                    HStack {
                        Text("Weight of items")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text(weight)
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                    HStack {
                        Text("Worth of Items")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text(worth)
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                    HStack {
                        Text("Tracking Number")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer(minLength: 0)
                        Text(trackNumber)
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                }
                Divider()
                    .padding(.top, 27)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Charges")
                        .robotoFont(size: 16, weight: .medium)
                        .foregroundStyle(Color.accentColor)
                    HStack {
                        Text("Delivery Charges")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text(String(format: "N%.2f", Double(2500 * sections.count)))
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                    HStack {
                        Text("Instant delivery")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text("N300.00")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                    HStack {
                        Text("Tax and Service Charges")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text(String(format: "N%.2f", getTax()))
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                    Divider()
                    HStack {
                        Text("Package total")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.customSecondaryText)
                        Spacer()
                        Text(String(format: "N%.2f", total()))
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color("CustomSecondaryColor"))
                        
                    }
                }
                if !isTrack {
                    HStack {
                        Button("Edit Package") {
                            dismiss()
                        }
                        .buttonStyle(SecondaryButtonStyle(width: 160))
                        Spacer()
                        Button("Make Payment") {
                            self.isNavigate = true
                        }
                        .buttonStyle(PrimaryButtonStyle(width: 160))
                    }
                    .padding(.top)
                    NavigationLink(destination: TransactionView(track: trackNumber), isActive: $isNavigate) {
                        EmptyView()
                    }
                } else {
                    VStack(spacing: 14) {
                        Text("Click on  delivered for successful delivery and rate rider or report missing item")
                            .robotoFont(size: 12, weight: .regular)
                            .foregroundStyle(Color.accentColor)
                        HStack {
                            Button("Report") {
                                
                            }
                            .buttonStyle(SecondaryButtonStyle(width: 160))
                            Spacer()
                            Button("Successful") {
                                self.isNavigateSuccessfull = true
                            }
                            .buttonStyle(PrimaryButtonStyle(width: 160))
                        }
                        .padding(.top)
                        NavigationLink(destination: DeliverySuccessView(track: trackNumber), isActive: $isNavigateSuccessfull) {
                            EmptyView()
                        }
                    }
                    .padding(.top, 24)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
        }
        .addNavigationTitle(title: "Send a package") {
            dismiss()
        }
    }
    
    private func total() -> Double {
        let dileviry: Double = 2500 * Double(sections.count)
        let instance: Double = 300
        let tax = getTax()
        
        return dileviry + instance + tax
    }
    
    private func getTax() -> Double {
        let dileviry: Double = 2500 * Double(sections.count)
        let instance: Double = 300
        let sum = dileviry + instance
        return sum * 0.05
    }
}

#Preview {
    ReceiptView(
        originAddress: "Origin Adress",
        originCountry: "Origin Country",
        originPhone: "Origin phone",
        originOthers: "Origin others",
        sections: [.init(address: "Destiatnion adress", country: "des country", phone: "des phone", others: "")],
        items: "items",
        weight: "weight",
        worth: "worth",
        trackNumber: "R-\(UUID().uuidString)",
        isTrack: true
    )
        .addNavigationStack()
}
