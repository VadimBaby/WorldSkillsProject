//
//  RealHomeView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 03.03.2024.
//

import SwiftUI

struct HomeListItem {
    let image: String
    let title: String
    let subtitle: String
}

struct RealHomeView: View {
    @StateObject private var viewModel: Self.ViewModel = .init()
    
    @State private var search: String = ""
    
    @State private var openSheet: Bool = false
    
    let list1: [HomeListItem] = [
        .init(image: "head", title: "Customer Care", subtitle: "Our customer care service line is available from 8 -9pm week days and 9 - 5 weekends - tap to call us today"),
        .init(image: "box", title: "Send a package", subtitle: "Request for a driver to pick up or deliver your package for you")
    ]
    
    let list2: [HomeListItem] = [
        .init(image: "wallet.fill", title: "Fund your wallet", subtitle: "To fund your wallet is as easy as ABC, make use of our fast technology and top-up your wallet today"),
        .init(image: "chat", title: "Chats", subtitle: "Search for available rider within your area")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                TextField("Search for a driver", text: $search)
                    .foregroundStyle(Color.customSecondaryText)
                    .padding()
                    .background(Color("TextFieldColor"))
                    .overlay(alignment: .trailing) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.customSecondaryText)
                            .padding(.trailing)
                    }
                HStack {
                    if let avatar = viewModel.avatar {
                        Button(action: {
                            self.openSheet.toggle()
                        }, label: {
                            if let viewModelImage = viewModel.image {
                                Image(uiImage: viewModelImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                if let image = UIImage(data: avatar) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Image("EmptyUser")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                }
                            }
                        })
                    } else {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                    VStack(alignment: .leading) {
                        Text("Hello \(viewModel.name)!")
                            .robotoFont(size: 24, weight: .medium)
                            .foregroundStyle(Color.white)
                        Text("We trust you are having a great time")
                            .robotoFont(size: 12)
                            .foregroundStyle(Color.customSecondaryText)
                    }
                    Spacer()
                    Image("notification")
                        .overlay {
                            Rectangle()
                                .fill(Color.white)
                                .mask {
                                    Image("notification")
                                }
                        }
                }
                .padding()
                .background(Color.accentColor)
                .clipShape(.rect(cornerRadius: 15))
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("What would you like to do")
                        .robotoFont(size: 16)
                        .foregroundStyle(Color.accentColor)
                    HStack {
                        ForEach(list1.indices, id: \.self) { index in
                            let item = list1[index]
                            
                            NavigationLink {
                                if index == 1 {
                                    SendPackage()
                                } else {
                                    Text(item.title)
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Image(item.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                    Text(item.title)
                                        .robotoFont(size: 18, weight: .medium)
                                        .foregroundStyle(Color.accentColor)
                                    Text(item.subtitle)
                                        .robotoFont(size: 12, weight: .regular)
                                        .foregroundStyle(Color.customBlack)
                                }
                                .padding()
                                .frame(width: 160, height: 160)
                                .background(Color("TextFieldColor"))
                                .clipShape(.rect(cornerRadius: 15))
                            }

                            
                            if index == 0 {
                                Spacer()
                            }
                        }
                    }
                    HStack {
                        ForEach(list2.indices, id: \.self) { index in
                            let item = list2[index]
                            
                            NavigationLink {
                                if index == 1 {
                                    ChatsView()
                                } else {
                                    Text(item.title)
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Image(item.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                    Text(item.title)
                                        .robotoFont(size: 18, weight: .medium)
                                        .foregroundStyle(Color.accentColor)
                                    Text(item.subtitle)
                                        .robotoFont(size: 12, weight: .regular)
                                        .foregroundStyle(Color.customBlack)
                                }
                                .padding()
                                .frame(width: 160, height: 160)
                                .background(Color("TextFieldColor"))
                                .clipShape(.rect(cornerRadius: 15))
                            }

                            
                            if index == 0 {
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $openSheet, content: {
                UIImagePickerControllerRepresentable(image: $viewModel.image, showScreen: $openSheet)
            })
        }
    }
}

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var showScreen: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        return vc
    }
    
    // from SwiftUI to UIKit
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        @Binding var showScreen: Bool
        
        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            
            self.image = image
            
            showScreen = false
        }
        
    }
}
