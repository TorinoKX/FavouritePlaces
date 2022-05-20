//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by zak on 29/4/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MasterList.name, ascending: true)],
        animation: .default)
    var locations: FetchedResults<MasterList>
    
    var body: some View {
        NavigationView {
            if locations.count > 0 {
                MasterView(locations: locations[0])
                //For iPads. If there's at least one location, display the detail view of the first location by default.
                if locations[0].locationsArray.count > 0 {
                    DetailView(location: locations[0].locationsArray[0])
                }
            }
            else {
                Text("Initliazing values")
                    .onAppear() {
                        LocationsService.shared.initLocations(viewContext: viewContext)
                    }
            }
        }
    }
}
