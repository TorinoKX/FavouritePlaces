//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by zak on 6/5/2022.
//

import SwiftUI

struct MasterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) var editMode
    
    @ObservedObject var masterList: MasterList
    
    var body: some View {
        if editMode?.wrappedValue == .active {
            TextField("List Title", text: $masterList.nameString)
                .font(Font.largeTitle.weight(.bold))
        }
        
        List {
            ForEach(masterList.locationsArray) { location in
                LocationRowView(location: location)
            }
            .onDelete {
                masterList.locationsArray.remove(atOffsets: $0)
            }
        }
        .navigationBarItems(leading: Button(action: {
            masterList.addNewLocation(viewContext)
        }) {
            Label("Add Item", systemImage: "plus")
        }, trailing: EditButton())
        .navigationTitle(editMode?.wrappedValue == .active ? "" : masterList.nameString)
    }
}
