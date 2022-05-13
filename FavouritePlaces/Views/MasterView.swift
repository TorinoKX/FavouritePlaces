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
    
    private func addItem() {
        withAnimation {
            let newItem = Location(context: viewContext)
            newItem.name = "New Place"
            newItem.desc = ""
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { locations[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
