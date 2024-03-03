//
//  CallRiderView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 03.03.2024.
//

import SwiftUI

struct CallRiderView: View {
    
    let chat: UserChatModel
    let avatar: Data?
    
    let list1: [String] = ["plus", "pause", "video"]
    let list2: [String] = ["speaker.wave.2", "mic.slash", "circle.grid.3x3"]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 80) {
            VStack {
                    if let avatar, let image = UIImage(data: avatar) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 84, height: 84)
                            .clipShape(Circle())
                    } else {
                        Image("EmptyUser")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 84, height: 84)
                            .clipShape(Circle())
                    }
                    Text(chat.user.name)
                        .robotoFont(size: 18, weight: .medium)
                        .foregroundStyle(Color.accentColor)
                    
                    Text(chat.user.phone)
                        .robotoFont(size: 18, weight: .regular)
                        .foregroundStyle(Color.customSecondaryText)
                    
                    Text("calling...")
                        .robotoFont(size: 14)
                        .foregroundStyle(Color.accentColor)
                }
                
                VStack(spacing: 30) {
                    HStack(spacing: 50) {
                        ForEach(list1, id: \.self) {
                            Image(systemName: $0)
                                .font(.title)
                                .foregroundStyle(Color.customBlack)
                        }
                    }
                    HStack(spacing: 50) {
                        ForEach(list2, id: \.self) {
                            Image(systemName: $0)
                                .font(.title)
                                .foregroundStyle(Color.customBlack)
                        }
                    }
                    Button(action: {
                        dismiss()
                    }, label: {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(systemName: "phone.down.fill")
                                    .foregroundStyle(Color.white)
                                    .font(.title)
                            }
                    })
                }
                .padding(50)
                .background(Color("TextFieldColor"))
                .clipShape(.rect(cornerRadius: 15))
            }
        .navigationBarBackButtonHidden()
    }
}
