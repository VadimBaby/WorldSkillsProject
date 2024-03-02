//
//  ChatsView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import SwiftUI

struct ChatsView: View {
    @StateObject private var viewModel: Self.ViewModel = .init()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            if viewModel.users != nil {
                VStack {
                    TextField("Search for a driver", text: $viewModel.search)
                        .foregroundStyle(Color.customSecondaryText)
                        .padding()
                        .background(Color("TextFieldColor"))
                        .overlay(alignment: .trailing) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.customSecondaryText)
                                .padding(.trailing)
                        }
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.filteredUsers, id: \.user.id) { chat in
                                ChatItemView(chat: chat)
                            }
                        }
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .addNavigationTitle(title: "Chats") {
            dismiss()
        }
    }
}
