//
//  ProfileView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct ProfileItem {
    let iconName: String
    let title: String
    let description: String?
    @ViewBuilder var destination: () -> AnyView
}

struct ProfileView: View {
    private let list: [ProfileItem] = [
        .init(iconName: "profile", title: "Edit Profile", description: "Name, phone no, address, email ...", destination: {
            AnyView(Text("Edit Profile"))
        }),
        .init(iconName: "reports", title: "Statements & Reports", description: "Download transaction details, orders, deliveries", destination: {
            AnyView(SendPackage())
        }),
        .init(iconName: "notification", title: "Notification Settings", description: "mute, unmute, set location & tracking setting", destination: {
            AnyView(NotificationView())
        }),
        .init(iconName: "card", title: "Card & Bank account settings", description: "change cards, delete card details", destination: {
            AnyView(AddPaymentView())
        }),
        .init(iconName: "referrals", title: "Referrals", description: "check no of friends and earn", destination: {
            AnyView(Text("Referrals"))
        }),
        .init(iconName: "aboutus", title: "About Us", description: "know more about us, terms and conditions", destination: {
            AnyView(Text("About Us"))
        })
    ]
    
    @State private var isHide: Bool = false
    @State private var enableDarkMode: Bool = false
    @State private var isNavigate: Bool = false
    
    @State private var balance: Double? = nil
    
    var body: some View {
        VStack {
            //HeaderView(title: "Profile", dismiss: nil)
            
            ScrollView {
                VStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 27)
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
                    
                    Toggle("Enable Dark Mode", isOn: $enableDarkMode)
                        .robotoFont(size: 16, weight: .medium)
                    
                    VStack(spacing: 12) {
                        ForEach(list, id: \.title) { item in
                            navigateItem(iconImage: item.iconName, title: item.title, description: item.description) {
                                item.destination()
                            }
                        }
                        Button(action: {
                            Task {
                                do {
                                    try await SupabaseManager.instance.logout()
                                    await MainActor.run {
                                        self.isNavigate = true
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }) {
                            HStack {
                                Image("logout")
                                    .resizable()
                                    .frame(width: 19, height: 19)
                                VStack(alignment: .leading) {
                                    Text("Log Out")
                                        .robotoFont(size: 16, weight: .medium)
                                        .foregroundStyle(Color.customBlack)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(Color.customBlack)
                            }
                        }
                        .padding()
                        .background {
                            Color.white
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        NavigationLink(
                            destination: LogInView(),
                            isActive: $isNavigate,
                            label: {
                                EmptyView()
                            })
                    }
                    .padding(.vertical)
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .addNavigationTitle(title: "Profile", closure: nil)
       // .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
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
    }
}

#Preview {
    ProfileView()
        .addNavigationStack()
}

extension ProfileView {
    @ViewBuilder func navigateItem<T: View>(iconImage: String, title: String, description: String?, destination: () -> T) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(iconImage)
                    .resizable()
                    .frame(width: 19, height: 19)
                VStack(alignment: .leading) {
                    Text(title)
                        .robotoFont(size: 16, weight: .medium)
                        .foregroundStyle(Color.customBlack)
                    if let description {
                        Text(description)
                            .robotoFont(size: 12)
                            .foregroundStyle(Color.customSecondaryText)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.customBlack)
            }
        }
        .padding()
        .background {
            Color.white
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}
