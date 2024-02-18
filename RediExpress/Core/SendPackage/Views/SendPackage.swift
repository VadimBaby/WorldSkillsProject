//
//  SendPackage.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 12.02.2024.
//

import SwiftUI
import MapKit

struct SendPackageSection {
    var address: String
    var country: String
    var phone: String
    var others: String
}

struct SendPackage: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var originaddress: String = ""
    @State private var origincountry: String = ""
    @State private var originphone: String = ""
    @State private var originothers: String = ""
    
    @State private var sections: [SendPackageSection] = [
        SendPackageSection(address: "", country: "", phone: "", others: "")
    ]
    
    @State private var items: String = ""
    @State private var weight: String = ""
    @State private var worth: String = ""
    
    @State private var isNavigate: Bool = false
    
    @State private var track: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("circle")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("Origin Details")
                                .robotoFont(size: 14, weight: .medium)
                        }
                        VStack {
                            TextField("Address", text: $originaddress)
                                .textFieldStyle(ShadowTextFieldStyle())
                            TextField("State, Country", text: $origincountry)
                                .textFieldStyle(ShadowTextFieldStyle())
                            TextField("Phone number", text: $originphone)
                                .textFieldStyle(ShadowTextFieldStyle())
                            TextField("Others", text: $originothers)
                                .textFieldStyle(ShadowTextFieldStyle())
                        }
                    }
                    .padding(.top, 27)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(sections.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                HStack {
                                    Image("marker")
                                        .resizable()
                                        .frame(width: 8, height: 13)
                                    Text("Destination Details")
                                        .robotoFont(size: 14, weight: .medium)
                                }
                                VStack {
                                    TextField("Address", text: $sections[index].address)
                                        .textFieldStyle(ShadowTextFieldStyle())
                                    TextField("State, Country", text: $sections[index].country)
                                        .textFieldStyle(ShadowTextFieldStyle())
                                    TextField("Phone number", text: $sections[index].phone)
                                        .textFieldStyle(ShadowTextFieldStyle())
                                    TextField("Others", text: $sections[index].others)
                                        .textFieldStyle(ShadowTextFieldStyle())
                                }
                            }
                        }
                        
                        Button(action: {
                            withAnimation(.none) {
                                self.sections.append(.init(address: "", country: "", phone: "", others: ""))
                            }
                        }, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.accentColor, lineWidth: 2)
                                    .frame(width: 14, height: 14)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                Text("Add destination")
                                    .robotoFont(size: 12, weight: .regular)
                                    .foregroundStyle(Color.customSecondaryText)
                            }
                        })
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Package Details")
                                    .robotoFont(size: 14, weight: .medium)
                            }
                            VStack {
                                TextField("package items", text: $items)
                                    .textFieldStyle(ShadowTextFieldStyle())
                                TextField("Weight of item(kg)", text: $weight)
                                    .textFieldStyle(ShadowTextFieldStyle())
                                TextField("Worth of items", text: $worth)
                                    .textFieldStyle(ShadowTextFieldStyle())
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Select delivery type")
                        
                        HStack {
                            Button(action: {
                                instanceDelivery()
                            }, label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.accentColor)
                                    .frame(width: 160, height: 75)
                                    .overlay {
                                        VStack {
                                            Image("clock")
                                            Text("Instant delivery")
                                                .foregroundStyle(Color.white)
                                                .robotoFont(size: 14, weight: .medium)
                                        }
                                    }
                            })
                            Spacer()
                            Button(action: {}, label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .frame(width: 160, height: 75)
                                    .shadow(radius: 5)
                                    .overlay {
                                        VStack {
                                            Image("calendar")
                                            Text("Scheduled delivery")
                                                .foregroundStyle(Color.customSecondaryText)
                                                .robotoFont(size: 14, weight: .medium)
                                        }
                                    }
                            })
                        }
                    }

                }
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 40)
                NavigationLink(
                    destination: ReceiptView(
                        originAddress: originaddress,
                        originCountry: origincountry,
                        originPhone: originphone,
                        originOthers: originothers,
                        sections: sections,
                        items: items,
                        weight: weight,
                        worth: worth,
                        trackNumber: track,
                        isTrack: false
                    ),
                    isActive: $isNavigate,
                    label: {
                        EmptyView()
                    })
            }
            .padding(.horizontal, 24)
        }
        .addNavigationTitle(title: "Send a package") {
            dismiss()
        }
        .onAppear {
            if let userLocation = LocationManager.instance.getLocation() {
                CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
                    if let place = placemarks?.first {
//                        text = "Country \(place.country ?? "error"), name: \(place.name ?? "error")"
                        
                        originaddress = place.name ?? ""
                        origincountry = place.country ?? ""
                    }
                }
            }
        }
    }
    
    private func instanceDelivery() {
        let trackNumber = UUID().returnTrack()
        
        self.track = trackNumber
        
        guard !originaddress.isEmpty,
              !origincountry.isEmpty,
              !originphone.isEmpty,
              !originphone.isEmpty,
                !items.isEmpty,
                !weight.isEmpty,
                !worth.isEmpty else { return }
        
        let someIsEmpty = sections.reduce(false) { partialResult, item in
            if partialResult {
                return true
            }
            
            return item.address.isEmpty || item.country.isEmpty || item.phone.isEmpty
        }
        
        if !someIsEmpty {
            Task {
                do {
                    let package: PackageModel = .init(
                        id: trackNumber,
                        created_at: .now,
                        origin_address: originaddress,
                        origin_state_country: origincountry,
                        origin_phone_number: originphone,
                        origin_others: originothers,
                        package_item: items,
                        weight_of_item: weight,
                        worth_of_items: worth,
                        customer_id: UUID(),
                        is_active: true
                    )
                    
                    try await SupabaseManager.instance.sendPackage(package: package, sections: sections)
                    
                    await MainActor.run {
                        self.isNavigate = true
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SendPackage()
}
