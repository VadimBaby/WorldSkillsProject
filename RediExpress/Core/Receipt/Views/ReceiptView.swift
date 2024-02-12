//
//  ReceiptView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI

struct ReceiptView: View {
    
    @State private var angle: Double = 0
    @State private var success: Bool = false
    
    let timer = Timer.publish(every: 0.001, on: .main, in: .common)
        .autoconnect()
    
    @State private var count: Double = 0
    
    let track: String
    
    @State private var navigateTrack: Bool = false
    @State private var navigateHome: Bool = false
    
    var body: some View {
        VStack {
                Spacer()
                .animation(.none, value: success)
                .animation(.none, value: angle)
                Group {
                    if success {
                        Image("success")
                            .resizable()
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
                    }
                    
                    Text("Your rider is on the way to your destination")
                        .robotoFont(size: 14, weight: .regular)
                    Text("Tracking Number:")
                        .robotoFont(size: 14, weight: .regular)
                        .multilineTextAlignment(.center)
                    Text(track)
                        .robotoFont(size: 14, weight: .regular)
                        .foregroundStyle(Color.accentColor)
                }
                .foregroundStyle(Color.customBlack)
                .padding(.top, 98)
                .animation(.none, value: success)
                .animation(.none, value: angle)
                
                Spacer()
                .animation(.none, value: success)
                .animation(.none, value: angle)
                
                VStack {
                    Button("Track My Item") {
                        self.navigateTrack = true
                    }
                    .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
                    
                    Button("Go back to homepage") {
                        self.navigateHome = true
                    }
                    .buttonStyle(SecondaryButtonStyle(maxWidth: .infinity))
                }
                .animation(.none, value: success)
                .animation(.none, value: angle)
            NavigationLink(isActive: $navigateTrack) {
                TrackingPackageView()
            } label: {
                EmptyView()
            }
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
    }
}

#Preview {
    ReceiptView(track: "R-\(UUID().uuidString)")
        .addNavigationStack()
}
