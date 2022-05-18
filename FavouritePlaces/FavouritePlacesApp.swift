//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by zak on 29/4/2022.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    let persistenceController = PersistenceController.shared
    static var locationsService: LocationsService = LocationsService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
