//
//  TrackingPackageView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI
import MapKit

struct TrackingPackageView: View {
    @State private var region: MKCoordinateRegion = .init(.world)
    
    @State private var isConnected: Bool = false
    
    @State private var isHaveActiveOrder: Bool = true
    @State private var order: OrderModel? = nil
    
    var body: some View {
        VStack {
            if isConnected {
                if isHaveActiveOrder {
                    if let order {
                        VStack(alignment: .leading, spacing: 22) {
                            Map(coordinateRegion: $region)
                                .frame(height: 270)
                                .ignoresSafeArea()
                            
                            VStack(alignment: .leading, spacing: 22) {
                                Text("Tracking Number")
                                    .robotoFont(size: 16, weight: .medium)
                                
                                HStack {
                                    Image("sun")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .background {
                                            Circle()
                                                .fill(Color.accentColor)
                                        }
                                    
                                    Text(order.package.id)
                                        .robotoFont(size: 16)
                                        .foregroundStyle(Color.accentColor)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                        }
                    } else {
                        ProgressView()
                    }
                } else {
                    Text("You don't have active order")
                }
            } else {
                Text("Check your WIFI")
            }
        }
        .onReceive(NetworkMonitor.instance.$isConnected, perform: { newValue in
            self.isConnected = newValue
        })
        .task {
            do {
                let order = try await SupabaseManager.instance.fetchLastPackage()
                await MainActor.run {
                    self.order = order
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    self.isHaveActiveOrder = false
                }
            }
        }
    }
}

#Preview {
    TrackingPackageView()
}
