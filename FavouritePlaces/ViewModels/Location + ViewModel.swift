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
