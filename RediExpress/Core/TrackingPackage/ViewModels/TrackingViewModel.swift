//
//  TrackingViewModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import Foundation
import Realtime
import MapKit
import Combine

struct Location: Identifiable {
    let id: String = UUID().uuidString
    let address: String
    let coordinate: CLLocationCoordinate2D?
    
    func setCoordinate(coordinate: CLLocationCoordinate2D) -> Location {
        return Location(address: address, coordinate: coordinate)
    }
}

extension TrackingPackageView {
    final class ViewModel: ObservableObject {
        @Published var order: OrderModel? = nil
        @Published var statusList: [StatusModel] = []
        
        @Published var locations: [Location] = []
        
        @Published var isNavigate: Bool = false
        
        private var statusListCancellable: AnyCancellable? = nil
        
        func setOrder(order: OrderModel) {
            self.order = order
            self.statusList = order.status
            
            order.destinations.forEach { item in
                self.locations.append(Location(address: item.address, coordinate: nil))
                getCoordinates(item.address) { coordinate in
                    guard let index = self.locations.firstIndex(where: {$0.address == item.address}) else { return }
                    
                    self.locations[index] = self.locations[index].setCoordinate(coordinate: coordinate)
                }
            }
            
            addSubcriberToStatus(idPackage: order.package.id)
            
            statusListCancellable = $statusList
                .receive(on: RunLoop.main)
                .sink { [weak self] statusList in
                    if statusList.count == 4 {
                        self?.isNavigate = true
                        self?.statusListCancellable?.cancel()
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
        
        private func addSubcriberToStatus(idPackage: String) {
            Task {
                let channel = await SupabaseManager.instance.getStatusChannel()
                
                Task {
                    for await update in await channel.postgresChange(InsertAction.self, schema: "public", table: "status", filter: "package_id=eq.\(idPackage)") {
                        do {
                            struct DecodeUpdate: Codable {
                                let id: String
                                let created_at: String
                                let status: String
                                let package_id: String
                            }
                            
                            let decodeUpdate = try update.decodeRecord(as: DecodeUpdate.self, decoder: JSONDecoder())
                            
                            let item = StatusModel(id: decodeUpdate.id, created_at: .now, status: decodeUpdate.status, package_id: decodeUpdate.package_id)
                                
                                
                            await MainActor.run {
                                self.statusList.append(item)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
                await channel.subscribe()
            }
        }
    }
}
