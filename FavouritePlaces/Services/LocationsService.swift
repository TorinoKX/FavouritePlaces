//
//  LocationsService.swift
//  FavouritePlaces
//
//  Created by zak on 18/5/2022.
//

import Foundation
import CoreData
import SwiftUI

class LocationsService {
    static let shared = LocationsService()
    
    private init() { }
    
    func initLocations(viewContext: NSManagedObjectContext) {
        let newItem = MasterList(context: viewContext)
        newItem.name = "Favourite Places"
        newItem.initLocations(viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
