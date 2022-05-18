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
    @ObservedObject var region: MapRegionViewModel
    @State var latitude = ""
    @State var longitude = ""
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region.region)
            if editMode?.wrappedValue == .active {
                HStack {
                    Text("Lat:")
                    TextField(region.latitude, text: $latitude, onCommit: {
                        region.latitude = latitude
                        latitude = ""
                    })
                }
                HStack {
                    Text("Lon:")
                    TextField(region.longitude, text: $longitude, onCommit: {
                        region.longitude = longitude
                        longitude = ""
                    })
                }
            }
            else {
                Text("Lat: \(region.latitude)")
                Text("Lon: \(region.longitude)")
            }
        }
    }
}
