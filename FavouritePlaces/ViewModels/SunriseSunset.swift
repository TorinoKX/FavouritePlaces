//
//  SunriseSunset.swift
//  FavouritePlaces
//
//  Created by zak on 23/5/2022.
//

import Foundation

/**
 A Codable struct that has a sunrise variable and a sunset variable, both are type String.
 */
struct SunriseSunset: Codable {
    var sunrise: String
    var sunset: String
}

/**
 A codable struct that has a result variable of type SunriseSunset and a status variable of type optional String.
 */
struct SunriseSunsetAPI: Codable {
    var results: SunriseSunset
    var status: String?
}
