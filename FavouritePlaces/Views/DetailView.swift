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
    @State var image = Image("Placeholder")
    @ObservedObject var location: Location
    @ObservedObject var region: MapRegionViewModel = MapRegionViewModel(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), latitudinalMeters: 5000, longitudinalMeters: 5000))
    @State var lat: String = ""
    @State var long: String = ""
    var body: some View {
        List {
            if editMode?.wrappedValue == .active {
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
                        TextField(location.lat, text: $lat, onCommit: {
                            location.lat = lat
                            region.region.center.latitude = location.latitude
                            lat = ""
                        })
                    }
                    HStack{
                        Text("Longitude: ")
                            .bold()
                        TextField(location.long, text: $long, onCommit: {
                            location.long = long
                            region.region.center.longitude = location.longitude
                            long = ""
                        })
                    }
                }
            } else {
                image.aspectRatio(contentMode: .fit)
                Text(location.locDesc)
                Text("Latitude: \(location.lat)\nLongitude: \(location.long)")
                NavigationLink {
                    LocationMapView(region: region)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                        }
                } label: {
                        MapRowView(region: region, location: location)
                }
            }
        }
        .navigationTitle(editMode?.wrappedValue == .active ? "Edit Details" : location.locName)
        .task {
            image = await location.getImage()
        }
        .onAppear() {
            region.region.center.latitude = location.latitude
            region.region.center.longitude = location.longitude
        }
    }
}


