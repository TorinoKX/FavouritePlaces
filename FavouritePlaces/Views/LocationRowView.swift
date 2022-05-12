//
//  LocationRowView.swift
//  FavouritePlaces
//
//  Created by zak on 8/5/2022.
//

import SwiftUI

struct LocationRowView: View {
    @ObservedObject var location: Location
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
            HStack{
                image.aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 25)
                Text(location.locName)
            }
        }.task {
            image = await location.getImage()
        }
    }
}
