//
//  SunriseSunsetView.swift
//  FavouritePlaces
//
//  Created by zak on 23/5/2022.
//

import SwiftUI

struct SunriseSunsetView: View {
    @ObservedObject var location: Location
    var body: some View {
        HStack{
            Label(location.sunriseString, systemImage: "sunrise")
            Spacer()
            Label(location.sunsetString,  systemImage: "sunset")
        }
    }
}
