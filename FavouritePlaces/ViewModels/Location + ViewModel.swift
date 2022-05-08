//
//  Location + ViewModel.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import Foundation
import CoreData
import SwiftUI

fileprivate let defaultImage = Image("Placeholder")
fileprivate var downloadedImages = [URL : Image]()

extension Location {
    
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
    
    var long: String {
        get { String(longitude) }
        set {
            guard let long = Double(newValue) else { return }
            longitude = long
            save()
        }
    }
    
    var lat: String {
        get { String(latitude) }
        set {
            guard let lat = Double(newValue) else { return }
            latitude = lat
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
