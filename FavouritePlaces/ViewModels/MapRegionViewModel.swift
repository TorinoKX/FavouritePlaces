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
    
    init(region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), latitudinalMeters: 5000, longitudinalMeters: 5000)){
        self.region = region
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
