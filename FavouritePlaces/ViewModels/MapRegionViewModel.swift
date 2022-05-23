//
//  MapRegionViewModel.swift
//  FavouritePlaces
//
//  Created by zak on 17/5/2022.
//

import Foundation
import MapKit

class MapRegionViewModel: ObservableObject {
    
    @Published var region: MKCoordinateRegion
    
    init(lat: Double, long: Double) {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
    
    var latitude: String {
        get { "\(region.center.latitude)" }
        set {
            guard let newLatitude = Double(newValue) else { return }
            region.center.latitude = newLatitude
        }
    }
    
    var longitude: String {
        get { "\(region.center.longitude)" }
        set {
            guard let newLongitude = Double(newValue) else { return }
            region.center.longitude = newLongitude
        }
    }
}
