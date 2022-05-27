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
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    @State var latitude = ""
    @State var longitude = ""
    @State var name = ""
    
    var body: some View {
        VStack {
            if editMode?.wrappedValue == .active {
                HStack {
                    Button(action: { LocationService.shared.lookupName(location.cLocation) {
                        (newName) -> Void in
                        location.locName = newName
                    }
                    }, label: {
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
            Map(coordinateRegion: $region)
                .disabled(editMode?.wrappedValue == .active ? false : true)
            if editMode?.wrappedValue == .active {
                HStack {
                    Button(action: {
                        LocationService.shared.lookupCoordinates(location.locName) {
                            (newLocation) -> Void in
                            location.cLocation = newLocation
                            region.center = newLocation.coordinate
                    }
                           }, label: {
                        Image(systemName: "globe.asia.australia")
                            .padding()
                    })
                    VStack {
                        HStack {
                            Text("Lat:")
                            TextField(region.latitudeString, text: $latitude, onCommit: {
                                region.latitudeString = latitude
                                latitude = ""
                            })
                        }
                        HStack {
                            Text("Lon:")
                            TextField(region.longitudeString, text: $longitude, onCommit: {
                                region.longitudeString = longitude
                                longitude = ""
                            })
                        }
                    }
                }
            }
            else {
                Text("Lat: \(region.latitudeString)")
                Text("Lon: \(region.longitudeString)")
            }
        }
        .onAppear() {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: 5000, longitudinalMeters: 5000)
        }
        .onDisappear() {
            location.latitudeString = region.latitudeString
            location.longitudeString = region.longitudeString
            guard let sunriseSunset = LocationService.shared.lookupSunriseAndSunset(location.latitudeString, location.longitudeString) else { return }
            location.sunriseSunset = sunriseSunset
        }
    }
}
