//
//  Locations + ViewModel.swift
//  FavouritePlaces
//
//  Created by zak on 19/5/2022.
//

import Foundation
import CoreData

extension MasterList {
    
    var nameString: String {
        get { name ?? "" }
        set {
            name = newValue
            save()
        }
    }
    
    var locationsArray: Array<Location> {
        get { locations?.array as? [Location] ?? [] }
        set {
            locations = NSOrderedSet(array: newValue)
            save()
        }
    }
    
    /**
     A function for adding a new location to the masterList.
     
     Creates a new location in the current viewContext (or the one supplied if it's unable to find it). Gives it some default values and adds it to the current masterList. Then saves the state.
     
     - Parameters:
        - viewContext: The viewContext to be saved to
     
     - Returns: Nothing
     */
    func addNewLocation(_ viewContext: NSManagedObjectContext) {
        let newLocation = Location(context: managedObjectContext ?? viewContext)
        newLocation.locName = "New Place"
        newLocation.locDesc = ""
        newLocation.masterList = self
        save()
    }
    
    /**
     A function to initialise the masterList with three default locations.
     
     Creates three locations with preset values, adds them to the masterList and saves the context.
     
     - Parameters:
        - viewContext: The viewContext to be saved to
     
     - Returns: Nothing
     */
    func initLocations(_ viewContext: NSManagedObjectContext) {
        let locationsArray = [
            Location(context: managedObjectContext ?? viewContext),
            Location(context: managedObjectContext ?? viewContext),
            Location(context: managedObjectContext ?? viewContext)
        ]
        
        locationsArray[0].locName = "Griffith Uni GC"
        locationsArray[0].locDesc = "Gold Coast Campus of Griffith University"
        locationsArray[0].urlString = "https://teanabroad.org/wp-content/uploads/2015/12/Griffith-Gold-Coast-Media-2-1.jpg"
        locationsArray[0].latitude = -27.9628349
        locationsArray[0].longitude = 153.3792395
        locationsArray[0].masterList = self
        
        locationsArray[1].locName = "Griffith Uni Nathan"
        locationsArray[1].locDesc = "Nathan Campus of Griffith University"
        locationsArray[1].urlString = "https://live-production.wcms.abc-cdn.net.au/a78b4c8618245511a98b093b4da19867?impolicy=wcms_crop_resize&cropH=627&cropW=941&xPos=21&yPos=0&width=862&height=575"
        locationsArray[1].latitude = -27.5530319
        locationsArray[1].longitude = 153.0489169
        locationsArray[1].masterList = self
        
        locationsArray[2].locName = "Kinkaku-ji"
        locationsArray[2].locDesc = "Temple of the golden pavilion"
        locationsArray[2].urlString = "https://s1.it.atcdn.net/wp-content/uploads/2015/06/shutterstock_197101637.jpg"
        locationsArray[2].latitude = 35.0393744
        locationsArray[2].longitude = 135.7270544
        locationsArray[2].masterList = self
        
        save()
    }
    
    /**
     A function to save the location's state to the current viewContext.
     
     - Returns: a boolean variable on if it has successfully saved or not
     */
    @discardableResult
    func save() -> Bool {
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error saving: \(error)")
            return false
        }
        return true
    }
}
