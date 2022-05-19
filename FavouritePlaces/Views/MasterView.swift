//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import SwiftUI

struct MasterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var locations: Locations
    
    var body: some View {
        List {
            ForEach(locations.locationsArray) { location in
                LocationRowView(location: location)
            }
            .onDelete {
                locations.locationsArray.remove(atOffsets: $0)
            }
        }
        .navigationBarItems(leading: Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
        }, trailing: EditButton())
        .navigationTitle(locations.nameString)
    }
    
    func addItem() {
        locations.addNewLocation(viewContext)
    }
}
