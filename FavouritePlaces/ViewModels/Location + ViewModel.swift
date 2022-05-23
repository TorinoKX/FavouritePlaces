//
//  Location + ViewModel.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import Foundation
import CoreData
import SwiftUI
import CoreLocation
import MapKit

fileprivate let defaultImage = Image("Placeholder")
fileprivate var downloadedImages = [URL : Image]()

extension Location {
    var cLocation: CLLocation {
        get { CLLocation(latitude: self.latitude, longitude: self.longitude) }
        set {
            self.latitude = newValue.coordinate.latitude
            self.longitude = newValue.coordinate.longitude
            save()
        }
    }
    
    var sunriseSunset: SunriseSunset {
        get { SunriseSunset(sunrise: sunrise ?? "unknown", sunset: sunset ?? "unknown")}
        set {
            sunrise = newValue.sunrise
            sunset = newValue.sunset
            save()
        }
    }
    
    var sunriseString: String {
        get { sunrise ?? "" }
        set {
            sunrise = newValue
            save()
        }
    }
    
    var sunsetString: String {
        get { sunset ?? "" }
        set {
            sunset = newValue
            save()
        }
    }
    
    var locName: String {
        get {name ?? ""}
        set {
            name = newValue
            save()
        }
    }
    
    var locDesc: String {
        get { desc ?? ""}
        set {
            desc = newValue
            save()
        }
    }
    
    var longitudeString: String {
        get { String(longitude) }
        set {
            guard let long = Double(newValue) else { return }
            if long >= -180 && long <= 180 {
                longitude = long
            }
            else { return }
            save()
        }
    }
    
    var latitudeString: String {
        get { String(latitude) }
        set {
            guard let lat = Double(newValue) else { return }
            if lat >= -90 && lat <= 90 {
                latitude = lat
            }
            else { return }
            save()
        }
    }
    
    var urlString: String {
        get { imgURL?.absoluteString ?? "" }
        set {
            guard let url = URL(string: newValue) else { return }
            imgURL = url
            save()
        }
    }
    
    
    /**
    An asynchronous function that will return the defaultImage if it cannot set the url variable or if it can't download the image. Otherwise it will return the image variable if it is already the downloadedImage. Otherwise it will download the image and return that.
     
     This function reads the url from the imgURL variable
     
     - Returns: An Image
     */
    func getImage() async -> Image {
        guard let url = imgURL else { return defaultImage }
        if let image = downloadedImages[url] { return image }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            print("Downloaded \(response.expectedContentLength) bytes.")
            guard let uiImg = UIImage(data: data) else { return defaultImage }
            let image = Image(uiImage: uiImg).resizable()
            downloadedImages[url] = image
            return image
        } catch {
            print("Error downloading \(url): \(error.localizedDescription)")
        }
        return defaultImage
    }
    
    /**
     A function to look up the coordinates of the location using CoreLocation's geocoder. Will print console messages if it cannot locate the location for whatever reason.
     
     Sets the location's cLocation variable to the returned value. Searches for the coordinates using the location's locName variable
     
     - Returns: Nothing
     */
    func lookupCoordinates() {
        let coder = CLGeocoder()
        coder.geocodeAddressString(self.locName) { optionalPlacemarks, optionalError in
            if let error = optionalError {
                print("Error looking up \(self.locName): \(error.localizedDescription)")
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
            self.cLocation = location
            print("\(self.cLocation.coordinate.latitude) \(self.cLocation.coordinate.longitude)")
        }
    }
    
    /**
     A function to look up the name of the location's coordinates using CoreLocation's reverse geocoder. Will print console messages if it cannot find a name for whatever reason.
     
     Sets the location's locName variable to the **formatted** returned value. Searches for the coordinates using the location's cLocation variable.
     
     - Returns: Nothing
     */
    func lookupName() {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(self.cLocation) { optionalPlacemarks, optionalError in
            if let error = optionalError {
                print("Error looking up \(self.cLocation.coordinate): \(error.localizedDescription)")
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
            self.locName = self.formatLocName(placemark: placemark)
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
        return self.locName
    }
    
    /**
     A function to look up the location's sunrise and sunset times for today using the sunrise-sunset.org api.
     
     Will print error messages to the console if it cannot look up the sunrise and sunset for whatever reason. This function will also convert the returned values to the SunriseSunset format. Stores the converted value in the location's sunriseSunset variable
     
     - Returns: Nothing
     */
    func lookupSunriseAndSunset() {
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitudeString)&lng=\(longitudeString)"
        guard let url = URL(string: urlString) else {
            print("Malformed URL: \(urlString)")
            return
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            print("Could not look up sunrise or sunset")
            return
        }
        guard let api = try? JSONDecoder().decode(SunriseSunsetAPI.self, from: jsonData) else {
            print("Could not decode JSON API:\n\(String(data: jsonData, encoding: .utf8) ?? "<empty>")")
            return
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
        sunriseSunset = converted
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
