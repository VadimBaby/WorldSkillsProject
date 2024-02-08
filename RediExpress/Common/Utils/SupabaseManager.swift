//
//  SupabaseManager.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let instance = SupabaseManager()
    
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://ojrdmoyefygpgzqyuemx.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qcmRtb3llZnlncGd6cXl1ZW14Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcyOTU2NDUsImV4cCI6MjAyMjg3MTY0NX0.ZgAyZ57Ga_qcX-632P8ZmtQ7r0bfN8fc-CVnpfupzV8")
    
    func signUp(name: String, phone: String, email: String, password: String) async throws {
        try await supabase.auth.signUp(
          email: email,
          password: password,
          data: [
              "display_name": .string(name),
            ]
        )
        
        try await supabase.auth.update(user: .init(phone: phone))
        
        try await supabase.auth.signOut()
    }
    
    func signIn(email: String, password: String) async throws {
        try await supabase.auth.signIn(
          email: email,
          password: password
        )
    }
    
    func sendOTP(email: String) async throws {
        try await supabase.auth.resetPasswordForEmail(email)
    }
    
    func verifyOTP(email: String, token: String) async throws {
        try await supabase.auth.verifyOTP(email: email, token: token, type: .recovery)
    }
    
    func resend(email: String) async throws {
        try await supabase.auth.resend(email: email, type: .emailChange)
    }
    
    func updatePassword(password: String) async throws {
        try await supabase.auth.update(user: .init(password: password))
    }
}
