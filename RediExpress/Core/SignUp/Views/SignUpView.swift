//
//  SignUpView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    
    @State private var checked: Bool = false
    
    @State private var stringError: String? = nil
    @State private var emailTextFieldError: Bool = false
    
    @State private var isNavigate: Bool = false
    
    @State private var showProgressView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 33) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create an account")
                        .robotoFont(size: 24)
                        .foregroundStyle(Color.customText)
                        .fontWeight(.medium)
                    Text("Complete the sign up process to get started")
                        .robotoFont(size: 14)
                        .foregroundStyle(Color.customSecondaryText)
                        .fontWeight(.medium)
                }
                
                VStack(spacing: 24) {
                    CustomTextField(
                        label: "Full Name",
                        placeholder: "Ivanov Ivan",
                        text: $name
                    )
                    CustomTextField(
                        label: "Phone Number",
                        placeholder: "+7(999)999-99-99",
                        text: $phone
                    )
                    .keyboardType(.phonePad)
                    CustomTextField(
                        label: "Email Address",
                        placeholder: "***********@mail.com",
                        text: $email,
                        isError: emailTextFieldError
                    )
                    CustomTextField(
                        label: "Password",
                        placeholder: "**********",
                        text: $password,
                        isSecure: true
                    )
                    CustomTextField(
                        label: "Confirmed Password",
                        placeholder: "**********",
                        text: $confirmedPassword,
                        isSecure: true
                    )
                }
                
                HStack(alignment: .top, spacing: 25) {
                    CheckBox(value: $checked)
                    VStack {
                        Text("By ticking this box, you agree to our")
                            .foregroundStyle(Color.customSecondaryText)
                        NavigationLink("Terms and conditions and private policy") {
                            PoliticyPDFView()
                        }
                        .foregroundStyle(Color.warning)
                    }
                    .robotoFont(size: 12)
                }
                
                VStack(spacing: 18) {
                    VStack {
                        Button(action: {
                            Task {
                                await MainActor.run {
                                    self.showProgressView = true
                                }
                                
                                let result = await signUp()
                                
                                if result {
                                    await MainActor.run {
                                        self.isNavigate = true
                                    }
                                }
                                
                                await MainActor.run {
                                    self.showProgressView = false
                                }
                            }
                        }, label: {
                            if showProgressView {
                                ProgressView()
                                    .tint(Color.white)
                            } else {
                                Text("Sign Up")
                            }
                        })
                        .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
                        
                        Spacer()
                        HStack(spacing: 1) {
                            Text("Already have an account?")
                                .robotoFont(size: 14)
                                .foregroundStyle(Color.customSecondaryText)
                            Button("Sign In") {
                                self.isNavigate = true
                            }
                            .robotoFont(size: 14)
                            .fontWeight(.medium)
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
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
        .alert(stringError ?? "", isPresented: Binding(error: $stringError)) {
            Button("OK") {
                self.stringError = nil
            }
        }
        .navigationDestination(isPresented: $isNavigate) {
            LogInView()
        }
    }
    
    private func signUp() async -> Bool {
        guard password.trim() == confirmedPassword.trim() else {
            return false
        }
        
        guard email.trim().validateEmail() else {
            emailTextFieldError = true
            stringError = "Write correct email"
            return false
        }
        
        emailTextFieldError = false
        
        guard name.count >= 1 && phone.count >= 1 && password.count >= 8 && checked else {
            return false
        }        
        
        return await signUpAsync(
            name: name.trim(),
            phone: phone.trim(),
            email: email.trim(),
            password: password.trim()
        )
    }
    
    func signUpAsync (
        name: String,
        phone: String,
        email: String,
        password: String
    ) async -> Bool {
        do {
            try await SupabaseManager.instance.signUp(name: name, phone: phone, email: email, password: password)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
