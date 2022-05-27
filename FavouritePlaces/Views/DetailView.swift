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
        if editMode?.wrappedValue == .active {
            DetailEditView(location: location, image: $image, lat: $lat, long: $long)
        } else {
            DetailItemsView(location: location, image: $image)
                .onAppear() {
                    guard let sunriseSunset = LocationService.shared.lookupSunriseAndSunset(location.latitudeString, location.longitudeString) else { return }
                    location.sunriseSunset = sunriseSunset
                }
                .task {
                    image = await location.getImage()
                }
        }
    }
}
