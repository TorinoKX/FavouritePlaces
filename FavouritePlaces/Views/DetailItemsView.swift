//
//  DetailItemsView.swift
//  FavouritePlaces
//
//  Created by zak on 23/5/2022.
//

import SwiftUI
import MapKit

struct DetailItemsView: View {
    @ObservedObject var location: Location
    @Binding var image: Image
    var body: some View {
        VStack {
            List {
                image.aspectRatio(contentMode: .fit)
                Text(location.locDesc)
                Text("Latitude: \(location.latitudeString)\nLongitude: \(location.longitudeString)")
                NavigationLink {
                    LocationMapView(location: location)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                        }
                        .navigationBarTitle("Map of \(location.locName)")
                } label: {
                    MapRowView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: 5000, longitudinalMeters: 5000),
                               location: location)
                }
            }
            .navigationTitle(location.locName)
            Spacer()
            SunriseSunsetView(location: location)
                .padding()
        }
    }
}
