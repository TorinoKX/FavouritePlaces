//
//  MapRowView.swift
//  FavouritePlaces
//
//  Created by zak on 18/5/2022.
//

import SwiftUI
import MapKit

struct MapRowView: View {
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    @ObservedObject var location: Location
    var body: some View {
        HStack{
            Map(coordinateRegion: $region)
                .frame(width: 32, height: 25)
                .disabled(true)
            Text("Map of \(location.locName)")
        }
        .onAppear() {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: 5000, longitudinalMeters: 5000)
        }
    }
}
