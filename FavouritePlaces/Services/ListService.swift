//
//  LocationsService.swift
//  FavouritePlaces
//
//  Created by zak on 18/5/2022.
//

import Foundation
import CoreData
import SwiftUI

class ListService {
    static let shared = ListService()
    
    private init() { }
    
    /**
     This function's purpose is to initialise the masterList and call its initLocations function to initialise the three default locations upon first launching the app.
     
     - Parameters:
        - viewContext: The viewcontext to save the list and locations to.
     
     - Returns: Nothing
     */
    func initList(viewContext: NSManagedObjectContext) {
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
