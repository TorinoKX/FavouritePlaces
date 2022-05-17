//
//  MapRegionViewModel.swift
//  FavouritePlaces
//
//  Created by zak on 17/5/2022.
//

import Foundation
import CoreLocation

class MapRegionViewModel: ObservableObject {
    @Published var location: CLLocation

    init(location: CLLocation) {
        self.location = location
    }
    
    var latitudeString: String {
        get { "\(location.coordinate.latitude)" }
        set {
            guard let newLatitude = Double(newValue) else { return }
            let newLocation = CLLocation(latitude: newLatitude, longitude: location.coordinate.longitude)
            location = newLocation
        }
    }
    var longitudeString: String {
        get { "\(location.coordinate.longitude)" }
        set {
            guard let newLongitude = Double(newValue) else { return }
            let newLocation = CLLocation(latitude: location.coordinate.latitude, longitude: newLongitude)
            location = newLocation
        }
    }
}
