//
//  WalletView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import SwiftUI

struct WalletView: View {
    @State private var transactions: [TransactionModel]? = nil
    
    @State private var isHide: Bool = false
    @State private var balance: Double? = nil
    
    @State private var isConnected: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 27)
            profileSection
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.customSecondaryText)
                .frame(height: 116)
                .overlay {
                    VStack {
                        Text("Top Up")
                            .robotoFont(size: 16, weight: .bold)
                            .foregroundStyle(Color.customBlack)
                        HStack {
                            Spacer()
                            topUpItem(name: "bank")
                            Spacer()
                            topUpItem(name: "transfer")
                            Spacer()
                            topUpItem(name: "card")
                            Spacer()
                        }
                    }
                }
            
            
            Text("Transaction History")
                .robotoFont(size: 20, weight: .medium)
                .foregroundStyle(Color.customBlack)
            
            if isConnected {
                if let transactions {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(transactions, id: \.id) { transaction in
                                HStack {
                                    Text("-N\(formatInt(number: transaction.total))")
                                        .foregroundStyle(Color.error)
                                    Spacer()
                                    Text(dateFormatter.string(from: transaction.created_at))
                                        .foregroundStyle(Color.customSecondaryText)
                                }
                                .padding()
                                .background {
                                    Color.white
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 10)
                                }
                            }
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 40)
                        }
                    }
                } else {
                    VStack {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                VStack {
                    Text("Check your WIFI")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.horizontal, 24)
        .addNavigationTitle(title: "Wallet", closure: nil)
        .onReceive(NetworkMonitor.instance.$isConnected, perform: { newValue in
            self.isConnected = newValue
        })
        .task {
            do {
                let balance = try await SupabaseManager.instance.getBalance()
                await MainActor.run {
                    self.balance = balance
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .task {
            do {
                let transactions = try await SupabaseManager.instance.fetchTransactions()
                
                await MainActor.run {
                    self.transactions = transactions
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func formatInt(number: Int) -> String {
        return String(format: "%.3f", Double(number) / 1000)
    }
}

extension WalletView {
    @ViewBuilder private var profileSection: some View {
        HStack {
            HStack {
                Image("QuickDelivery")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .scaledToFit()
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Hello Ken")
                        .robotoFont(size: 16, weight: .medium)
                    HStack(spacing: 0) {
                        Text("Current balance: ")
                        if let balance {
                            Text(isHide ? "*******" : "\(String(format: "%.0f", balance))")
                                .foregroundStyle(Color.accentColor)
                        } else {
                            Text(isHide ? "*******" : "Loading...")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .robotoFont(size: 12)
                }
                
            }
            Spacer()
            Button(action: {
                self.isHide.toggle()
            }, label: {
                Image(systemName: isHide ? "eye" : "eye.slash")
                    .font(.system(size: 14))
                    .tint(Color.black)
            })
        }
    }
    
    @ViewBuilder private func topUpItem(name: String) -> some View {
        HStack {
            VStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(name + ".white")
                            .scaledToFit()
                            .frame(width: 21, height: 21)
                    }
                Text(name.capitalized)
                    .robotoFont(size: 12)
                    .foregroundStyle(Color.customBlack)
            }
        }
    }
}

#Preview {
    WalletView()
        .addNavigationStack()
}
