//
//  MapRowView.swift
//  FavouritePlaces
//
//  Created by zak on 18/5/2022.
//

import SwiftUI
import MapKit

struct MapRowView: View {
    @ObservedObject var region: MapRegionViewModel
    @ObservedObject var location: Location
    var body: some View {
        HStack{
        Map(coordinateRegion: $region.region)
            .frame(width: 32, height: 25)
            .disabled(true)
        Text("Map of \(location.locName)")
        }
    }
}
