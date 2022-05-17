//
//  LocationMapView.swift
//  FavouritePlaces
//
//  Created by zak on 17/5/2022.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @Binding var region: MKCoordinateRegion

    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
            HStack {
                Text("Lat:")
                TextField("Enter Latitude", text: $region.latitudeString)
            }
            HStack {
                Text("Lon:")
                TextField("Enter Longitude", text: $region.longitudeString)
            }
        }
    }
}
