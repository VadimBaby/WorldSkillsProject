//
//  ForgotPasswordView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email: String = ""
    @State private var showProgressView: Bool = false
    
    @State private var disabled: Bool = true
    
    @State private var isNavigate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 56) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Forget Password")
                    .robotoFont(size: 24, weight: .medium)
                    .foregroundStyle(Color.customText)
                Text("Enter your email adress")
                    .robotoFont(size: 14, weight: .medium)
                    .foregroundStyle(Color.customSecondaryText)
            }
            
            CustomTextField(
                label: "Email Address",
                placeholder: "***********@mail.com",
                text: $email
            )
            
            VStack(spacing: 18) {
                VStack {
                    Button(action: {
                        resetPassword()
                    }, label: {
                        if showProgressView {
                            ProgressView()
                                .tint(Color.white)
                        } else {
                            Text("Send OTP")
                        }
                    })
                    .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity, disabled: disabled))
                    .disabled(disabled)
                    
                    Spacer()
                    HStack(spacing: 1) {
                        Text("Remember password? Back to ")
                            .robotoFont(size: 14)
                            .foregroundStyle(Color.customSecondaryText)
                        NavigationLink("Sign In", destination: {
                            LogInView()
                        })
                        .robotoFont(size: 14, weight: .medium)
                        .foregroundStyle(Color.customPrimary)
                    }
                }
                .frame(height: 82, alignment: .top)
                
                VStack {
                    Text("or sign in using")
                        .robotoFont(size: 14)
                        .foregroundStyle(Color.customSecondaryText)
                    Image("google")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                
                if #unavailable(iOS 16.0) {
                    NavigationLink(
                        destination: OTPVerificationView(email: email.trim()),
                        isActive: $isNavigate,
                        label: {
                            EmptyView()
                        })
                }
            }
        }
        .onChange(of: email, perform: { newValue in
            self.disabled = !email.validateEmail()
        })
//        .onChange(of: email, { _, newValue in
//            self.disabled = !email.validateEmail()
//        })
        .padding(.horizontal, 24)
       // .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .addNavigationDestination(isPresented: $isNavigate) {
            OTPVerificationView(email: email.trim())
        }
    }
    
    private func resetPassword() {
        Task {
            await MainActor.run {
                self.showProgressView = true
            }
            
            do {
                try await SupabaseManager.instance.sendOTP(email: email.trim())
                await MainActor.run {
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

#Preview {
    ForgotPasswordView()
        .addNavigationStack()
}
