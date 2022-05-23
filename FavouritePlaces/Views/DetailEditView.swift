//
//  DetailEditView.swift
//  FavouritePlaces
//
//  Created by zak on 20/5/2022.
//

import SwiftUI

struct DetailEditView: View {
    @ObservedObject var location: Location
    @Binding var image: Image
    @Binding var lat: String
    @Binding var long: String
    
    var body: some View {
        TextField("Name of Location", text: $location.locName)
            .font(Font.largeTitle.weight(.bold))
        TextField("Image URL", text: $location.urlString)
            .onSubmit {
                Task{
                    image = await location.getImage()
                }
            }
        VStack{
            Text("Location Description:")
                .bold()
            TextEditor(text: $location.locDesc)
                .frame(height: 120, alignment: .center)
        }
        VStack {
            HStack{
                Text("Latitiude: ")
                    .bold()
                TextField(location.latitudeString, text: $lat, onCommit: {
                    location.latitudeString = lat
                    lat = ""
                })
            }
            HStack{
                Text("Longitude: ")
                    .bold()
                TextField(location.longitudeString, text: $long, onCommit: {
                    location.longitudeString = long
                    long = ""
                })
            }
        }
    }
}
