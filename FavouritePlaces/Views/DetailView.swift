//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.editMode) var editMode
    @State var image = Image("Placeholder")
    var location: Location
    var body: some View {
        List {
            if editMode?.wrappedValue == .active {
                
            } else {
                image.aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                Text(location.locDesc)
                Text("Latitude: \(location.lat) \nLongitude: \(location.long)")
            }
        }
        .navigationTitle(location.locName)
        .task {
            image = await location.getImage()
        }
    }
}

