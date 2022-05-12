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
        }
    }
}
