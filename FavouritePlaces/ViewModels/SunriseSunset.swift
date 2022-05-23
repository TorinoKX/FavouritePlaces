//
//  SunriseSunset.swift
//  FavouritePlaces
//
//  Created by zak on 23/5/2022.
//

import Foundation

struct SunriseSunset: Codable {
    var sunrise: String
    var sunset: String
}

struct SunriseSunsetAPI: Codable {
    var results: SunriseSunset
    var status: String?
}
