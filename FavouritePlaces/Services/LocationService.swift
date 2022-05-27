//
//  LocationService.swift
//  FavouritePlaces
//
//  Created by zak on 26/5/2022.
//

import Foundation
import CoreLocation

class LocationService {
    
    static let shared = LocationService()
    
    private init() { }
    
    /**
     A function to look up the coordinates of the location using CoreLocation's geocoder. Will print console messages if it cannot locate the location for whatever reason.
     
     Sets the location's cLocation variable to the returned value. Searches for the coordinates using the location's locName variable
     
     - Returns: Optional CLLocation
     */
    func lookupCoordinates(_ nameString: String, _ callback: @escaping (CLLocation) -> Void) -> Void {
        let coder = CLGeocoder()
        coder.geocodeAddressString(nameString) { optionalPlacemarks, optionalError in
            if let error = optionalError {
                print("Error looking up \(nameString): \(error.localizedDescription)")
                return
            }
            guard let placemarks = optionalPlacemarks, !placemarks.isEmpty else {
                print("Placemarks came back empty")
                return
            }
            let placemark = placemarks[0]
            guard let location = placemark.location else {
                print("Placemark has no location")
                return
            }
            callback(location)
        }
    }
    
    /**
     A function to look up the name of the location's coordinates using CoreLocation's reverse geocoder. Will print console messages if it cannot find a name for whatever reason.
     
     Sets the location's locName variable to the **formatted** returned value. Searches for the coordinates using the location's cLocation variable.
     
     - Returns: Nothing
     */
    func lookupName(_ location: CLLocation, _ callback: @escaping (String) -> Void) -> Void {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) { (optionalPlacemarks, optionalError) -> Void in
            if let error = optionalError {
                print("Error looking up \(location.coordinate): \(error.localizedDescription)")
                return
            }
            guard let placemarks = optionalPlacemarks, !placemarks.isEmpty else {
                print("Placemarks came back empty")
                return
            }
            let placemark = placemarks[0]
            for value in [
                \CLPlacemark.name,
                 \.country,
                 \.isoCountryCode,
                 \.postalCode,
                 \.administrativeArea,
                 \.subAdministrativeArea,
                 \.locality,
                 \.subLocality,
                 \.thoroughfare,
                 \.subThoroughfare
            ] {
                print(String(describing: placemark[keyPath: value]))
            }
            callback(self.formatLocName(placemark: placemark))
        }
    }
    
    /**
     A function to format a given CLPlacemark variable to a readable string value.
     
     Converts to name of the location **OR** name of the suburb of the location **OR** some combination of the locatlity, thoroughfare, and subthoroughfare **OR** state depending on what is given in the placemark.
     
     - Parameters:
        - placemark: A CLPlacemark variable to be converted to a name/Suburb/Address String
     
     - Returns: A string value of the converted placemark value. Otherwise if it cannot convert the value it will return the location's current name.
     */
    func formatLocName(placemark: CLPlacemark) -> String {
        if let name = placemark.name {
            return name
        }
        if let local = placemark.locality {
            if let tFare = placemark.thoroughfare {
                if let subTFare = placemark.subThoroughfare {
                    return "\(subTFare) \(tFare), \(local)"
                }
                else {
                    return "\(tFare), \(local)"
                }
            }
            else {
                return "\(local)"
            }
        }
        if let suburb = placemark.subAdministrativeArea {
            return suburb
        }
        if let state = placemark.administrativeArea {
            return state
        }
        return ""
    }
    
    /**
     A function to look up the location's sunrise and sunset times for today using the sunrise-sunset.org api.
     
     Will print error messages to the console if it cannot look up the sunrise and sunset for whatever reason. This function will also convert the returned values to the SunriseSunset format. Stores the converted value in the location's sunriseSunset variable
     
     - Returns: Optional SunriseSunset
     */
    func lookupSunriseAndSunset(_ latitude: String, _ longitude: String) -> SunriseSunset? {
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)"
        guard let url = URL(string: urlString) else {
            print("Malformed URL: \(urlString)")
            return nil
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            print("Could not look up sunrise or sunset")
            return nil
        }
        guard let api = try? JSONDecoder().decode(SunriseSunsetAPI.self, from: jsonData) else {
            print("Could not decode JSON API:\n\(String(data: jsonData, encoding: .utf8) ?? "<empty>")")
            return nil
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateStyle = .none
        inputFormatter.timeStyle = .medium
        inputFormatter.timeZone = .init(secondsFromGMT: 0)
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .none
        outputFormatter.timeStyle = .medium
        outputFormatter.timeZone = .current
        var converted = api.results
        if let time = inputFormatter.date(from: api.results.sunrise) {
            converted.sunrise = outputFormatter.string(from: time)
        }
        if let time = inputFormatter.date(from: api.results.sunset) {
            converted.sunset = outputFormatter.string(from: time)
        }
        return converted
    }
}
