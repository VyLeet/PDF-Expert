//
//  NewEntryView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 01.06.2021.
//

import SwiftUI

struct NewEntryView: View {
    @Binding var newEntryName: String
    @Binding var newEntryIsBeingEntered: Bool
    @Binding var newEntryType: EntryType?
    var currentFolder: Entry?
    
    var body: some View {
        VStack {
            TextField(newEntryType == .f ? "File name" : "Folder name", text: $newEntryName)
                .padding(.horizontal)
                .font(.title)
            
            HStack(spacing: 30) {
                Button("Add") {
                    makeEntry()
                    withAnimation {
                        newEntryIsBeingEntered = false
                    }
                    newEntryType = nil
                }
                .padding()
                .frame(width: 100)
                .background(Color("LightGray"))
                .cornerRadius(20)
                .disabled(true)
                .foregroundColor(.secondary)
                
                Button("Cancel") {
                    withAnimation {
                        newEntryIsBeingEntered = false
                    }
                    newEntryType = nil
                }
                .padding()
                .frame(width: 100)
                .background(Color("LightGray"))
                .foregroundColor(.black)
                .cornerRadius(20)
            }
        }
        .padding()
    }
    
    /// Creates a new Entry object
    @discardableResult
    private func makeEntry() -> Entry {
        Entry(id: UUID(), parentID: currentFolder?.id, itemType: newEntryType!.rawValue, itemName: newEntryName)
    }
}

struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView(newEntryName: .constant("Summer"), newEntryIsBeingEntered: .constant(true), newEntryType: .constant(.d), currentFolder: Entry(id: UUID(), parentID: nil, itemType: "d", itemName: "Vacations"))
    }
}
