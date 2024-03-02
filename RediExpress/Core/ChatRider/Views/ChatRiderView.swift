//
//  ChatRiderView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import SwiftUI
import Realtime

struct ChatRiderView: View {
    @StateObject private var viewModel: Self.ViewModel
    
    @State private var avatar: Data? = nil
    
    let chat: UserChatModel
    
    init(chat: UserChatModel) {
        self.chat = chat
        
        self._viewModel = StateObject(wrappedValue: .init(person: chat.user.id))
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State private var message: String = ""
    
    var body: some View {
        GeometryReader { geo in
            mainSection {
                VStack {
                        if let messages = viewModel.messages {
                            ScrollView {
                                LazyVStack {
                                    ForEach(messages, id: \.message.id) { message in
                                        Text(message.message.message)
                                            .foregroundStyle(
                                                message.myMessage ? Color.white : Color.customBlack
                                            )
                                            .padding(8)
                                            .background(
                                                message.myMessage ? Color.accentColor : Color("TextFieldColor")
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .frame(maxWidth: .infinity, alignment: message.myMessage ? .trailing : .leading)
                                    }
                                }
                                .padding()
                            }
                        } else {
                            VStack {
                                ProgressView()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    HStack {
                        Image("Emoji")
                            .resizable()
                            .frame(width: 20, height: 20)
                        TextField("Enter message", text: $message)
                            .padding(.horizontal)
                            .padding(.leading)
                            .frame(height: 40)
                            .background(Color.customSecondaryText)
                            .clipShape(.rect(cornerRadius: 15))
                            .overlay(alignment: .trailing) {
                                Image(systemName: "mic")
                                    .padding(.trailing)
                                    .foregroundStyle(Color.customBlack)
                            }
                        Button(action: {
                            if !message.isEmpty {
                                viewModel.sendMessage(message: message)
                                message = ""
                            }
                        }, label: {
                            Image("triangle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        })
                    }
                    .padding(.leading)
                    .padding(.bottom)
                }
            }
        }
    }
}

extension ChatRiderView {
    @ViewBuilder private func mainSection<Content: View>(content: () -> Content) -> some View {
        ZStack(alignment: .top) {
            content()
                .padding(.top, 55)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
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
                Spacer()
                HStack(alignment: .top) {
                    if let avatar {
                        if let image = UIImage(data: avatar) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        } else {
                            Image("EmptyUser")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        }
                    } else {
                        ProgressView()
                            .frame(width: 45, height: 45)
                    }
                    Text(chat.user.name)
                        .robotoFont(size: 16, weight: .regular)
                        .foregroundStyle(Color.customBlack)
                }
                .frame(maxHeight: .infinity)
                Spacer()
                Image(systemName: "phone")
                    .foregroundStyle(Color.accentColor)
            }
            .padding(.horizontal)
            .frame(height: 55)
            .background {
                GeometryReader { geo in
                    Color.white
                        .shadow(color: .black, radius: 15, x: 0, y: -20)
                        .mask(Rectangle().padding(.bottom, -20))
                }
            }
        }
        .navigationBarHidden(true)
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
