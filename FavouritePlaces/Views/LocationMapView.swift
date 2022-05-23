//
//  LocationMapView.swift
//  FavouritePlaces
//
//  Created by zak on 17/5/2022.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @Environment(\.editMode) var editMode
    @ObservedObject var location: Location
    @ObservedObject var region: MapRegionViewModel
    @State var latitude = ""
    @State var longitude = ""
    @State var name = ""
    
    init(location: Location) {
        self.location = location
        self.region = MapRegionViewModel(lat: location.latitude, long: location.longitude)
    }
    
    var body: some View {
        VStack {
            if editMode?.wrappedValue == .active {
                HStack {
                    Button(action: lookupName, label: {
                        Image(systemName: "magnifyingglass.circle")
                            .padding()
                    })
                    HStack {
                        Text("Location Name:")
                        TextField(location.locName, text: $name, onCommit: {
                            location.locName = name
                            name = ""
                        })
                    }
                }
            }
            Map(coordinateRegion: $region.region)
                .disabled(editMode?.wrappedValue == .active ? false : true)
            if editMode?.wrappedValue == .active {
                HStack {
                    Button(action: location.lookupCoordinates, label: {
                        Image(systemName: "globe.asia.australia")
                            .padding()
                    })
                    VStack {
                        HStack {
                            Text("Lat:")
                            TextField(region.latitude, text: $latitude, onCommit: {
                                location.latitudeString = latitude
                                latitude = ""
                            })
                        }
                        HStack {
                            Text("Lon:")
                            TextField(region.longitude, text: $longitude, onCommit: {
                                location.longitudeString = longitude
                                longitude = ""
                            })
                        }
                    }
                }
            }
            else {
                Text("Lat: \(region.latitude)")
                Text("Lon: \(region.longitude)")
            }
        }
        .onDisappear() {
            location.latitudeString = region.latitude
            location.longitudeString = region.longitude
        }
    }
    
    func lookupName() {
        location.latitudeString = region.latitude
        location.longitudeString = region.longitude
        location.lookupName()
    }
}
