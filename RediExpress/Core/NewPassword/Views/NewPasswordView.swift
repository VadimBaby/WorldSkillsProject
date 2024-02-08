//
//  NewPasswordView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct NewPasswordView: View {
    
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    
    @State private var showProgressView: Bool = false
    @State private var disabled: Bool = true
    
    @State private var isNavigate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 70) {
            VStack(alignment: .leading, spacing: 8) {
                Text("New Password")
                    .robotoFont(size: 24)
                    .foregroundStyle(Color.customText)
                    .fontWeight(.medium)
                Text("Enter new password")
                    .robotoFont(size: 14)
                    .foregroundStyle(Color.customSecondaryText)
                    .fontWeight(.medium)
            }
            VStack(spacing: 24) {
                CustomTextField(
                    label: "Password",
                    placeholder: "**********",
                    text: $password,
                    isSecure: true
                )
                CustomTextField(
                    label: "Confirm Password",
                    placeholder: "**********",
                    text: $confirmedPassword,
                    isSecure: true
                )
            }
            Button(action: {
                updatePassword()
            }, label: {
                if showProgressView {
                    ProgressView()
                        .tint(Color.white)
                } else {
                    Text("Log In")
                }
            })
            .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity, disabled: disabled))
            .disabled(disabled)
        }
        .onChange(of: password, { _, newValue in
            guard newValue.count >= 8 && confirmedPassword.count >= 8 else { return }
            
            disabled = newValue != confirmedPassword
        })
        .onChange(of: confirmedPassword, { _, newValue in
            guard password.count >= 8 && newValue.count >= 8 else { return }
            
            disabled = password != newValue
        })
        .navigationBarBackButtonHidden()
        .padding(.horizontal, 24)
        .navigationDestination(isPresented: $isNavigate) {
            HomeView()
        }
    }
    
    private func updatePassword() {
        Task {
            await MainActor.run {
                self.showProgressView = true
            }
            
            do {
                try await SupabaseManager.instance.updatePassword(password: password)
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
    NavigationStack {
        NewPasswordView()
    }
}
