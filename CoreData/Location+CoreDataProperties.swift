//
//  Location+CoreDataProperties.swift
//  FavouritePlaces
//
//  Created by zak on 4/5/2022.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var desc: String?
    @NSManaged public var imgURL: URL?
    @NSManaged public var lat: String?
    @NSManaged public var long: String?
    @NSManaged public var name: String?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension Location {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: NSManagedObject)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: NSManagedObject)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
