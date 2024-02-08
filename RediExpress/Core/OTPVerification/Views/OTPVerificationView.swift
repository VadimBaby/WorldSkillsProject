//
//  OTPVerificationView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI

struct OTPVerificationView: View {
    let email: String
    
    @State private var letters: [String] = Array(repeating: "", count: 6)
    
    @State private var showProgressView: Bool = false
    @State private var disabled: Bool = true
    
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
    
    @State private var count: Int = 60
    
    @State private var hasError: Bool = false
    
    @State private var isNavigate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 52) {
            VStack(alignment: .leading, spacing: 8) {
                Text("OTP Verification")
                    .robotoFont(size: 24)
                    .foregroundStyle(Color.customText)
                    .fontWeight(.medium)
                Text("Enter the 6 digit numbers sent to your email")
                    .robotoFont(size: 14)
                    .foregroundStyle(Color.customSecondaryText)
                    .fontWeight(.medium)
            }
            VStack(spacing: 82) {
                VStack(spacing: 30) {
                    HStack {
                        ForEach(letters.indices, id: \.self) { index in
                            rectangleTextField(text: $letters[index], hasError: hasError)
                            
                            if index != letters.count - 1 {
                                Spacer()
                            }
                        }
                        
                    }
                    HStack(spacing: 0) {
                        Text("If you didn’t receive code, ")
                            .robotoFont(size: 14)
                            .foregroundStyle(Color.customSecondaryText)
                            .fontWeight(.medium)
                        Group {
                            if count >= 0 {
                                Text("resend after \(count == 60 ? "1:00" : count > 9 ? "0:\(count)" : "0:0\(count)")")
                                    .robotoFont(size: 14)
                                    .foregroundStyle(Color.customSecondaryText)
                                    .fontWeight(.medium)
                            } else {
                                Button("resend") {
                                    resend()
                                }
                                .robotoFont(size: 14)
                                .foregroundStyle(Color.customPrimary)
                            }
                        }
                    }
                }
                Button(action: {
                    sendOTP()
                }, label: {
                    if showProgressView {
                        ProgressView()
                            .tint(Color.white)
                    } else {
                        Text("Set New Password")
                    }
                })
                .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity, disabled: disabled))
                .disabled(disabled)
            }
        }
        .navigationBarBackButtonHidden()
        .padding(.horizontal, 24)
        .onReceive(timer, perform: { _ in
            if count >= 0 {
                count -= 1
            } else {
                stopTimer()
            }
        })
        .onChange(of: letters) { _, newValue in
            disabled = letters.reduce(true, { partialResult, letter in
                return letter.isEmpty
            })
        }
        .navigationDestination(isPresented: $isNavigate) {
            NewPasswordView()
        }
    }
    
    private func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
    }
    
    private func resend() {
        startTimer()
        
        Task {
            do {
                try await SupabaseManager.instance.sendOTP(email: email)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendOTP() {
        let token = letters.reduce("") { partialResult, letter in
            return partialResult + letter
        }
        
        Task {
            await MainActor.run {
                self.showProgressView = true
            }
            
            do {
                try await SupabaseManager.instance.verifyOTP(email: email, token: token)
                await MainActor.run {
                    self.showProgressView = false
                    self.isNavigate = true
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    self.hasError = true
                    self.showProgressView = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OTPVerificationView(email: "someemail")
    }
}

extension OTPVerificationView {
    @ViewBuilder func rectangleTextField(text: Binding<String>, hasError: Bool) -> some View {
        TextField("", text: text)
            .multilineTextAlignment(.center)
            .frame(width: 32, height: 32)
            .overlay {
                Rectangle()
                    .stroke(hasError ? Color.error : text.wrappedValue.isEmpty ? Color.customSecondaryText : Color.customPrimary, lineWidth: 1)
            }
            .keyboardType(.numberPad)
    }
}
