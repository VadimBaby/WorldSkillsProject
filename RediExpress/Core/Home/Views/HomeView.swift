//
//  HomeView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct TabItem {
    let title: String
    let iconName: String
}

enum Tabs: String, CaseIterable {
    case home, wallet, track, profile
    
    var tabItem: TabItem {
        switch self {
        case .home:
            TabItem(title: "Home", iconName: "house")
        case .wallet:
            TabItem(title: "Wallet", iconName: "wallet")
        case .track:
            TabItem(title: "Track", iconName: "car")
        case .profile:
            TabItem(title: "Profile", iconName: "profile")
        }
    }
    
    @ViewBuilder var view: some View {
        switch self {
        case .home:
            Text("Home")
        case .wallet:
            WalletView()
        case .track:
            TrackingPackageView()
        case .profile:
            ProfileView()
        }
    }
}

struct HomeView: View {
    
    @State private var selection: Tabs = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            selection.view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                ForEach(Tabs.allCases, id: \.rawValue) { tab in
                    VStack {
                        Rectangle()
                            .fill(selection == tab ? Color.accentColor : Color.clear)
                            .frame(width: 35, height: 2)
                            .shadow(radius: 5)
                        Image("\(tab.tabItem.iconName)\(selection == tab ? ".active" : "")")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(tab.tabItem.title)
                            .robotoFont(size: 12)
                            .foregroundStyle(Color.customSecondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selection = tab
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background {
                Color.white
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 5)
                    .mask(Rectangle().padding(.top, -20))
            }
        }
      //  .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .onAppear {
            LocationManager.instance.requestPermission()
        }
    }
}

#Preview {
    HomeView()
        .addNavigationStack()
}
