//
//  ChatItemView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import SwiftUI
import Realtime

struct ChatItemView: View {
    @State private var avatar: Data? = nil
    
    let chat: UserChatModel
    
    var body: some View {
        NavigationLink(destination: {
            ChatRiderView(chat: chat)
        }, label: {
            HStack {
                if let avatar {
                    if let image = UIImage(data: avatar) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Image("EmptyUser")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                } else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
                VStack(alignment: .leading) {
                    Text(chat.user.name)
                        .robotoFont(size: 16, weight: .medium)
                        .foregroundStyle(Color.customBlack)
                    
                    if let message = chat.message {
                        Text(message.message)
                            .robotoFont(size: 16)
                            .foregroundStyle(Color.customBlack)
                    }
                }
                Spacer()
            }
        })
        .padding()
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.customSecondaryText, lineWidth: 1)
        }
        .task {
            do {
                print(chat.user.name + " " + chat.user.id.uuidString)
                let data = try await SupabaseManager.instance.fetchAvatar(id: chat.user.id.uuidString)
                await MainActor.run {
                    self.avatar = data
                }
            } catch {
                print("Error " + error.localizedDescription)
                await MainActor.run {
                    self.avatar = .init()
                }
            }
        }
    }
}
