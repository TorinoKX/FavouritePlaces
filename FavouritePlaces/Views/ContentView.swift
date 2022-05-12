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
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.name, ascending: true)],
        animation: .default)
    private var locations: FetchedResults<Location>

    var body: some View {
        NavigationView {
            MasterView(locations: locations)
            //For iPads. If there's at least one location, display the detail view of the first location by default.
            if locations.count > 0 {
                DetailView(location: locations[0])
            }
        }
    }
}
