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
            DetailView(location: location);
        } label: {
            image.aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 25, alignment: .center)
            Text(location.name!)
        }.task {
            image = await location.getImage()
        }
    }
}
