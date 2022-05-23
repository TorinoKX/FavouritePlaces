//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @Environment(\.editMode) var editMode
    
    @ObservedObject var location: Location
    @State var image = Image("Placeholder")
    @State var lat: String = ""
    @State var long: String = ""
    
    var body: some View {
        List {
            if editMode?.wrappedValue == .active {
                DetailEditView(location: location, image: $image, lat: $lat, long: $long)
            } else {
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
                    MapRowView(region: MapRegionViewModel(lat: location.latitude, long: location.longitude),
                               location: location)
                }
            }
        }
        .navigationTitle(editMode?.wrappedValue == .active ? "Edit Details" : location.locName)
        .task {
            image = await location.getImage()
        }
    }
}
