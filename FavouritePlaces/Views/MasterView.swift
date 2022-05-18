//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import SwiftUI

struct MasterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var locations: FetchedResults<Location>
    
    var body: some View {
        List {
            ForEach(locations) { location in
                LocationRowView(location: location)
            }
            .onDelete(perform: deleteItems)
        }
        .navigationBarItems(leading: Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
        }, trailing: EditButton())
        .navigationTitle("Favourite Places")
    }
    
    func addItem() {
        FavouritePlacesApp.locationsService.addItem(viewContext: viewContext)
    }
    
    func deleteItems(index: IndexSet) {
        FavouritePlacesApp.locationsService.deleteItems(offsets: index, viewContext: viewContext, locations: locations)
    }
}
