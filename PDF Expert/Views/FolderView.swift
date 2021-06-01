//
//  FolderView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import SwiftUI

enum EntryType: String {
    case f, d
}

/// The Main App View
struct FolderView: View {
    /// Is nil if current folder is Root. Otherwise contains current folder
    var currentFolder: Entry?
    
    /// UserDefaults property storing layout. true – table, false – grid
    @AppStorage("isTableLayout") private var isTableLayout = true
    
    /// Controls sheet presence
    @State private var newEntryIsBeingEntered = false
    @State private var newEntryName = ""
    @State private var newEntryType: EntryType?
    
    /// Maintains .navigationTitle
    var currentFolderName: String {
        if currentFolder != nil {
            return currentFolder!.itemName
        } else {
            return "Main Folder"
        }
    }
    
    /// Array containing all entries
    @Binding var entries: [Entry]
    
    /// Maintatins LazyVGrid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    /// Filtered entries for current folder
    var correctEntries: Array<Entry> {
        var array = Array<Entry>()
        
        for entry in entries {
            if currentFolder != nil {
                if entry.parentID == currentFolder?.id {
                    array.append(entry)
                }
            } else {
                if entry.parentID == nil {
                    array.append(entry)
                }
            }
        }
        
        return array
    }
    
    var body: some View {
        VStack {
            if newEntryIsBeingEntered {
                NewEntryView(newEntryName: $newEntryName, newEntryIsBeingEntered: $newEntryIsBeingEntered, newEntryType: $newEntryType)
            }
            /// Table layout
            if isTableLayout {
                List(correctEntries) { entry in
                    /// Navigation Link for folders
                    if entry.itemType == "d" {
                        NavigationLink(
                            destination: FolderView(currentFolder: entry, entries: $entries),
                            label: {
                                TableEntryView(name: entry.itemName, imageName: "folder")
                            })
                        /// Plain label for files
                    } else {
                        TableEntryView(name: entry.itemName, imageName: "doc.richtext")
                    }
                }
                /// Grid layout
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(correctEntries) { entry in
                            /// Navigation Link for folders
                            if entry.itemType == "d" {
                                NavigationLink(
                                    destination: FolderView(currentFolder: entry, entries: $entries),
                                    label: {
                                        GridEntryView(name: entry.itemName, imageName: "folder")
                                    })
                                /// Plain label for files
                            } else {
                                GridEntryView(name: entry.itemName, imageName: "doc.richtext")
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(currentFolderName)
        .toolbar {
            HStack(spacing: 30) {
                Button {
                    // TODO: - NO IMPLEMENTATION YET
                } label: {
                    Image(systemName: "person")
                }
                .disabled(true)
                
                Button {
                    if newEntryType == .f {
                        withAnimation {
                            newEntryIsBeingEntered = false
                        }
                        newEntryType = nil
                    } else if newEntryType == .d {
                        newEntryType = .f
                    } else {
                        withAnimation {
                            newEntryIsBeingEntered = true
                        }
                        newEntryType = .f
                    }
                } label: {
                    Image(systemName: "doc.badge.plus")
                }
                
                Button {
                    if newEntryType == .d {
                        withAnimation {
                            newEntryIsBeingEntered = false
                        }
                        newEntryType = nil
                    } else if newEntryType == .f {
                        newEntryType = .d
                    } else {
                        withAnimation {
                            newEntryIsBeingEntered = true
                        }
                        newEntryType = .d
                    }
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
                
                Button {
                    isTableLayout.toggle()
                } label: {
                    Image(systemName: isTableLayout ? "square.grid.2x2" : "list.dash")
                }
            }
            .imageScale(.large)
        }
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(currentFolder: nil, entries: .constant([]))
    }
}
