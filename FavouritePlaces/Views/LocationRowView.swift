//
//  LocationRowView.swift
//  FavouritePlaces
//
//  Created by zak on 8/5/2022.
//

import SwiftUI

struct LocationRowView: View {
    var location: Location
    @State var image = Image("Placeholder").resizable()
    var body: some View {
        NavigationLink {
            DetailView(location: location)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
        } label: {
            image.aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32, alignment: .center)
            Text(location.locName)
        }.task {
            image = await location.getImage()
        }
    }
}
