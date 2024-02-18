//
//  DeliverySuccessView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import SwiftUI

struct DeliverySuccessView: View {
    @State private var angle: Double = 0
    @State private var success: Bool = false
    
    @State private var count: Double = 0
    
    let track: String
    
    @State private var navigateHome: Bool = false
    
    @State private var feedback: String = ""
    
    @State private var rate: Int = 0
    
    @State private var can: Bool = true
    
    var body: some View {
        VStack {
                Spacer()
                .animation(.none, value: success)
                .animation(.none, value: angle)
                Group {
                    if success {
                        Image("success")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 119, height: 119)
                            .animation(.none, value: angle)
                    } else {
                        Circle()
                            .stroke(
                                AngularGradient(colors: [Color.orange, Color.white], center: .center, startAngle: Angle(degrees: angle), endAngle: Angle(degrees: angle + 360))
                                , style: .init(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: 119, height: 119)
                    }
                }
                .frame(width: 119, height: 119)
                VStack(spacing: 8) {
                    if success {
                        Text("Transaction Successful")
                            .robotoFont(size: 24, weight: .medium)
                        Text("Your Item has been delivered successfully")
                            .robotoFont(size: 14, weight: .regular)
                    }
                }
                .foregroundStyle(Color.customBlack)
                .padding(.top, 58)
                .animation(.none, value: success)
                .animation(.none, value: angle)
                .frame(height: 190)
            
            VStack(spacing: 25) {
                    Text("Rate Rider")
                        .robotoFont(size: 14)
                        .foregroundStyle(Color.accentColor)
                HStack(spacing: 16) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: "star.fill")
                                .foregroundStyle(rate >= index ? Color.warning : Color.customSecondaryText)
                                .onTapGesture {
                                    self.rate = index
                                }
                        }
                    }
                    HStack {
                        Image("feedback")
                            .resizable()
                            .frame(width: 16, height: 16)
                        TextField("Add feedback", text: $feedback)
                            .robotoFont(size: 15)
                            .foregroundStyle(Color.customSecondaryText)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
                
                Spacer()
                .animation(.none, value: success)
                .animation(.none, value: angle)
                
            Button("Done") {
                Task {
                    do {
                        try await SupabaseManager.instance.sendFeedback(rate: rate, feedback: feedback, track: track)
                        await MainActor.run {
                            self.navigateHome = true
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
                .animation(.none, value: success)
                .animation(.none, value: angle)
            NavigationLink(isActive: $navigateHome) {
                HomeView()
            } label: {
                EmptyView()
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .onAppear {
            withAnimation(.linear(duration: 2)) {
                self.angle = 360 * -2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.success = true
            })
        }
        .navigationBarHidden(true)
        .onReceive(DeviceMotionMonitor.instance.$angle, perform: { newValue in
            if newValue > 50 && can && rate < 5 {
                rate += 1
                can = false
            }
            if newValue < -50 && can && rate > 0 {
                rate -= 1
                can = false
            }
            
            if newValue > -50 && newValue < 50 && !can {
                can = true
            }
        })
    }
}

#Preview {
    DeliverySuccessView(track: UUID().uuidString)
}
