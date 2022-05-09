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
    @ObservedObject var location: Location
    var body: some View {
        List {
            if editMode?.wrappedValue == .active {
                TextField("Enter Name of Location", text: $location.locName)
                TextField("Enter Image URL", text: $location.urlString)
                    .onSubmit {
                        Task{
                            image = await location.getImage()
                        }
                    }
                VStack{
                    Text("Enter Location Description:")
                        .bold()
                    TextField("", text: $location.locDesc)
                }
                VStack {
                    HStack{
                        Text("Latitiude: ")
                            .bold()
                        TextField("", text: $location.lat)
                    }
                    HStack{
                        Text("Longitude: ")
                            .bold()
                        TextField("", text: $location.long)
                    }
                }
            } else {
                image.aspectRatio(contentMode: .fit)
                Text(location.locDesc)
                Text("Latitude: \(location.lat)\nLongitude: \(location.long)")
            }
        }
        .navigationTitle(location.locName)
        .task {
            image = await location.getImage()
        }
    }
}

