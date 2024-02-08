//
//  LogInView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct LogInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showProgressView: Bool = false
    @State private var checkedPassword: Bool = false
    
    @State private var isNavigate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 33) {
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome Back")
                    .robotoFont(size: 24)
                    .foregroundStyle(Color.customText)
                    .fontWeight(.medium)
                Text("Fill in your email and password to continue")
                    .robotoFont(size: 14)
                    .foregroundStyle(Color.customSecondaryText)
                    .fontWeight(.medium)
            }
            VStack(spacing: 17) {
                VStack(spacing: 24) {
                    CustomTextField(
                        label: "Email Address",
                        placeholder: "***********@mail.com",
                        text: $email
                    )
                    CustomTextField(
                        label: "Password",
                        placeholder: "**********",
                        text: $password,
                        isSecure: true
                    )
                }
                HStack {
                    HStack {
                        CheckBox(value: $checkedPassword)
                        Text("Remember password")
                            .robotoFont(size: 14)
                            .foregroundStyle(Color.customSecondaryText)
                            .fontWeight(.medium)
                    }
                    Spacer()
                    NavigationLink("Forgot Password?") {
                        ForgotPasswordView()
                    }
                    .robotoFont(size: 14)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.customPrimary)
                    
                }
            }
            Spacer()
            VStack(spacing: 18) {
                VStack {
                    Button(action: {
                        signIn()
                    }, label: {
                        if showProgressView {
                            ProgressView()
                                .tint(Color.white)
                        } else {
                            Text("Sign In")
                        }
                    })
                    .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
                    
                    Spacer()
                    HStack(spacing: 1) {
                        Text("Already have an account?")
                            .robotoFont(size: 14)
                            .foregroundStyle(Color.customSecondaryText)
                        NavigationLink("Sign Up", destination: {
                            SignUpView()
                        })
                        .robotoFont(size: 14)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.customPrimary)
                    }
                }
                .frame(height: 82, alignment: .top)
                
                VStack {
                    Text("or log in using")
                        .robotoFont(size: 14)
                        .foregroundStyle(Color.customSecondaryText)
                    Image("google")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isNavigate) {
            HomeView()
        }
    }
}

#Preview {
    NavigationStack {
        LogInView()
    }
}

extension LogInView {
    func signIn() {
        guard password.count >= 8 && email.validateEmail() else {
            return
        }
        
        Task {
            
            await MainActor.run {
                self.showProgressView = true
            }
            
            do {
                try await SupabaseManager.instance.signIn(email: email.trim(), password: password)
                await MainActor.run {
                    KeyChainManager.instance.savePassword(password: password)
                    self.isNavigate = true
                }
            } catch {
                print(error.localizedDescription)
            }
            
            await MainActor.run {
                self.showProgressView = false
            }
        }
    }
}
