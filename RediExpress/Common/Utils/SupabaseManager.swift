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
    private let status: String = "status"
    private let feedbacks: String = "feedbacks"
    
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
    
    // разлогинивается
    func logout() async throws {
        try await supabase.auth.signOut()
    }
    
    // получает баланс авторизованного пользователя
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
    
    // создает предмет доставки и все данные для него
    func sendPackage(package: PackageModel, sections: [SendPackageSection]) async throws {
        let user = try await supabase.auth.session.user
        
        let charges: Int = 2500 * sections.count
        let instant: Int = 300
        let tax: Int = Int(round(Double((charges + instant)) * 0.05))
        let total: Int = charges + instant + tax
        
        let transaction = TransactionModel(id: UUID().uuidString, created_at: .now, charges: charges, instant: instant, tax_and_services_charges: tax, total: total, package_id: package.id, customer_id: user.id)
        
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
        
        let status = StatusModel(id: UUID().uuidString, created_at: .now, status: "сourier_requested", package_id: mypackage.id)
        
        try await supabase.database
            .from(self.status)
            .insert(status)
            .execute()
    }
    
    // получает все транзакции пользователя
    func fetchTransactions() async throws -> [TransactionModel] {
        let user = try await supabase.auth.session.user
        
        let transactions: [TransactionModel] = try await supabase.database
          .from(transactions)
          .select()
          .eq("customer_id", value: user.id)
          .execute()
          .value
        
        return transactions.sorted(by: {
            return $0.created_at > $1.created_at
        })
    }
    
    // получает последую активныю доставку пользователя
    func fetchLastPackage() async throws -> OrderModel {
        let user = try await supabase.auth.session.user
        
        let packages: [PackageModel] = try await supabase.database
            .from(packages)
            .select()
            .eq("is_active", value: true)
            .eq("customer_id", value: user.id)
            .execute()
            .value
        
        let sortedPackages = packages.sorted {$0.created_at > $1.created_at}
        
        guard let package = sortedPackages.first else { throw URLError(.badServerResponse) }
        
        let destinations: [DestinationModel] = try await supabase.database
            .from(destinations)
            .select()
            .eq("package_id", value: package.id)
            .execute()
            .value
        
        let listStatus: [StatusModel] = try await supabase.database
            .from(self.status)
            .select()
            .eq("package_id", value: package.id)
            .execute()
            .value
        
        return OrderModel(package: package, destinations: destinations, status: listStatus)
    }
    
    func getStatusChannel() async -> RealtimeChannelV2 {
        return await supabase.realtimeV2.channel("public:status")
    }
    
    func sendFeedback(rate: Int, feedback: String, track: String) async throws {
        guard feedback.count < 11 else { return }
        
        let user = try await supabase.auth.session.user
        
        let feedbackModel = FeedbackModel(id: UUID().uuidString, created_at: .now, package_id: track, customer_id: user.id, rate: rate, feedback: feedback)
        
        try await supabase.database
            .from(feedbacks)
            .insert(feedbackModel)
            .execute()
    }
}
