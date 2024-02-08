//
//  HomeView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
