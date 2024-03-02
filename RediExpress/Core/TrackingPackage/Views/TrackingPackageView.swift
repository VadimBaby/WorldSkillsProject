//
//  TrackingPackageView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI
import MapKit



struct TrackingPackageView: View {
    @StateObject private var viewModel: Self.ViewModel = .init()
    
    private let listNames: [String] = ["Courier requested" , "Package ready for delivery", "Package in transit", "Package delivered"]
    
    @State private var region: MKCoordinateRegion = .init(.world)
    
    @State private var isConnected: Bool = false
    
    @State private var isHaveActiveOrder: Bool = true
    
    @State private var isNavigate: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, HH:mm"
        
        return formatter
    }
    
    var body: some View {
        VStack {
            if isConnected {
                if isHaveActiveOrder {
                    if let order = viewModel.order {
                        VStack(alignment: .leading, spacing: 22) {
                            Map(coordinateRegion: $region,
                                showsUserLocation: true,
                                annotationItems: viewModel.locations,
                                annotationContent: { location in
                                if let coordinate = location.coordinate {
                                    MapMarker(coordinate: coordinate)
                                } else {
                                    MapMarker(coordinate: .init())
                                }
                            })
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
                                    
                                    Text("Package Status")
                                        .robotoFont(size: 14)
                                        .foregroundStyle(Color.customSecondaryText)
                                }
                                
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(listNames.indices, id: \.self) { index in
                                            let listStatus = viewModel.statusList
                                            
                                            if listStatus.count > index {
                                                getStatusItem(
                                                    name: listNames[index],
                                                    date: dateFormatter.string(from: listStatus[index].created_at),
                                                    type: .active)
                                            } else if listStatus.count == index {
                                                getStatusItem(
                                                    name: listNames[index],
                                                    date: dateFormatter.string(from: listStatus[index - 1].created_at),
                                                    type: .processing
                                                )
                                            } else {
                                                getStatusItem(
                                                    name: listNames[index],
                                                    date: dateFormatter.string(from: listStatus.last?.created_at ?? Date()),
                                                    type: .disable
                                                )
                                            }
                                        }
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(height: 60)
                                        Button("View Package Info") {
                                            self.isNavigate = true
                                        }
                                        .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(height: 60)
                                        NavigationLink(
                                            destination: SendPackage(),
                                            isActive: $isNavigate,
                                            label: {
                                                EmptyView()
                                            })
                                        NavigationLink(
                                            destination: ReceiptView(
                                                originAddress: order.package.origin_address, originCountry: order.package.origin_state_country, originPhone: order.package.origin_phone_number, originOthers: order.package.origin_others ?? "",
                                                sections: order.destinations.map({
                                                    SendPackageSection(address: $0.address, country: $0.state_country, phone: $0.phone_number, others: $0.others ?? "")
                                                }), items: order.package.package_item, weight: order.package.weight_of_item, worth: order.package.worth_of_items, trackNumber: order.package.id,
                                            isTrack: true),
                                            isActive: $viewModel.isNavigate,
                                            label: {
                                                EmptyView()
                                            })
                                    }
                                    .frame(maxWidth: .infinity)
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
                    viewModel.setOrder(order: order)
                }
            } catch {
                debugPrint(error)
                await MainActor.run {
                    self.isHaveActiveOrder = false
                }
            }
        }
    }
    
    private func getCoordinates(_ address: String,completion: @escaping((CLLocationCoordinate2D) -> ())){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {  return }
            DispatchQueue.main.async {
                completion(location.coordinate)
            }
        }
    }
}

extension TrackingPackageView {
    enum TypeStatusItem {
        case active, processing, disable
    }
    
    @ViewBuilder private func getStatusItem(
        name: String,
        date: String,
        type: TypeStatusItem
    ) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0) {
                Rectangle()
                    .fill(type == .active ? Color.accentColor : type == .processing ? Color.white : Color.customSecondaryText)
                    .frame(width: 14, height: 14)
                    .overlay {
                        Group {
                            if type == .processing {
                                Rectangle()
                                    .fill(Color.white)
                                    .border(Color.accentColor, width: 1)
                            }
                        }
                        .overlay {
                            Group {
                                if type == .active {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 8, height: 8)
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }
                    }
                if name != "Package delivered" {
                    Rectangle()
                        .fill(Color.customSecondaryText)
                        .frame(width: 1, height: 44)
                }
            }
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundStyle(type == .processing ? Color.accentColor : Color.customSecondaryText)
                Text(date)
                    .foregroundStyle(Color.orange)
            }
        }
    }
}

#Preview {
    TrackingPackageView()
}
