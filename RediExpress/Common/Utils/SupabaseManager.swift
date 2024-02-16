//
//  SupabaseManager.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import Foundation
import Supabase

// класс для работы с Supabase

final class SupabaseManager {
    // singleton
    static let instance = SupabaseManager()
    
    private let user_info: String = "user_info"
    private let packages: String = "packages"
    private let destinations: String = "destinations"
    private let transactions: String = "transactions"
    
    // подключение supabase
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://ojrdmoyefygpgzqyuemx.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qcmRtb3llZnlncGd6cXl1ZW14Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcyOTU2NDUsImV4cCI6MjAyMjg3MTY0NX0.ZgAyZ57Ga_qcX-632P8ZmtQ7r0bfN8fc-CVnpfupzV8")
    
    func isLogIn() async -> Bool {
        do {
            let _ = try await supabase.auth.session
            
            return true
        } catch {
            return false
        }
    }
    
    // регистрация
    func signUp(name: String, phone: String, email: String, password: String) async throws {
        try await supabase.auth.signUp(
          email: email,
          password: password,
          data: [
              "display_name": .string(name),
            ]
        )
        
        try await supabase.auth.update(user: .init(phone: phone))
        
        let user = try await supabase.auth.session.user
        
        let userinfo = UserInfoModel(id: user.id, created_at: .now, balance: 0)

        try await supabase.database
          .from(user_info)
          .insert(userinfo)
          .execute()
        
        try await supabase.auth.signOut()
    }
    
    // вход
    func signIn(email: String, password: String) async throws {
        try await supabase.auth.signIn(
          email: email,
          password: password
        )
    }
    
    // отправка кода для сброса пароля
    func sendOTP(email: String) async throws {
        try await supabase.auth.resetPasswordForEmail(email)
    }
    
    // проверка кода
    func verifyOTP(email: String, token: String) async throws {
        try await supabase.auth.verifyOTP(email: email, token: token, type: .recovery)
    }
    
    // установление нового пароля
    func updatePassword(password: String) async throws {
        try await supabase.auth.update(user: .init(password: password))
    }
    
    func logout() async throws {
        try await supabase.auth.signOut()
    }
    
    func getBalance() async throws -> Double {
        let user = try await supabase.auth.session.user
        
        let users: [UserInfoModel] = try await supabase.database
            .from(user_info)
            .select()
            .eq("id", value: user.id)
            .execute()
            .value
        
        guard let first = users.first else { throw URLError(.badServerResponse) }
        
        return first.balance
    }
    
    func sendPackage(package: PackageModel, sections: [SendPackageSection]) async throws {
        let charges: Int = 2500 * sections.count
        let instant: Int = 300
        let tax: Int = Int(round(Double((charges + instant)) * 0.05))
        let total: Int = charges + instant + tax
        
        let transaction = TransactionModel(id: UUID().uuidString, created_at: .now, charges: charges, instant: instant, tax_and_services_charges: tax, total: total, package_id: package.id)
        
        let user = try await supabase.auth.session.user
        
        let mypackage = package.changeCustomer(customerId: user.id)
        
        let destinations = sections.map { section in
            return DestinationModel(
                id: UUID(),
                address: section.address,
                state_country: section.country,
                phone_number: section.phone,
                others: section.others,
                package_id: mypackage.id,
                customer_id: user.id,
                created_at: .now
            )
        }
        
        try await supabase.database
          .from(packages)
          .insert(mypackage)
          .execute()
        
        for item in destinations {
            try await supabase.database
                .from(self.destinations)
                .insert(item)
                .execute()
        }
        
        try await supabase.database
            .from(self.transactions)
            .insert(transaction)
            .execute()
    }
}
