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
    
    func addItem(viewContext: NSManagedObjectContext) {
        let newItem = Location(context: viewContext)
        newItem.name = "New Place"
        newItem.desc = ""
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteItems(offsets: IndexSet, viewContext: NSManagedObjectContext, locations: FetchedResults<Location>) {
        offsets.map { locations[$0] }.forEach(viewContext.delete)
        
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
