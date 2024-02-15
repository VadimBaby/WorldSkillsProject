//
//  LocationManager.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 13.02.2024.
//

import Foundation
import MapKit
import SwiftUI

final class LocationManager {
    static let instance = LocationManager()
    
    private let locationMonitor: CLLocationManager = .init()
    
    func requestPermission() {
        if locationMonitor.authorizationStatus == .notDetermined {
            locationMonitor.requestWhenInUseAuthorization()
        }
    }
    
    func getLocation() -> CLLocation? {
        return locationMonitor.location
    }
}


/* if locationManager.authorizationStatus == .notDetermined {
 locationManager.requestWhenInUseAuthorization()
}

locationManager.startUpdatingHeading()

if let userLocation = locationManager.location {
 CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
     if let place = placemarks?.first {
//                        text = "Country \(place.country ?? "error"), name: \(place.name ?? "error")"
         
         originaddress = place.name ?? ""
         origincountry = place.country ?? ""
     }
 }
}*/
