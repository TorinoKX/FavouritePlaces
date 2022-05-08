//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import SwiftUI

struct DetailView: View {
    var location: Location;
    var body: some View {
        Text(location.name!)
    }
}

