//
//  FolderView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import SwiftUI

/// The Main App View
struct FolderView: View {
    /// Is nil if current folder is Root. Otherwise contains current folder
    var currentFolder: Entry?
    
    /// UserDefaults property storing layout. true – table, false – grid
    @AppStorage("isTableLayout") private var isTableLayout = true
    
    /// Maintains .navigationTitle
    @State private var currentFolderName = "Main Folder"
    
    /// Array containing all entries
    @State private var entriesToDisplay = Array<Entry>()
    
    /// Maintatins LazyVGrid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    /// FolderView sole initializer
    /// - Parameter currentFolder: Folder of state, nil means root folder.
    init(currentFolder: Entry?) {
        self.currentFolder = currentFolder
        
        if currentFolder != nil {
            _currentFolderName = State(wrappedValue: currentFolder!.itemName)
        }
    }
    
    /// Filtered entries for current folder
    var correctEntries: Array<Entry> {
        var array = Array<Entry>()
        
        for entry in entriesToDisplay {
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
        Group {
            /// Table layout
            if isTableLayout {
                List(correctEntries) { entry in
                    /// Navigation Link for folders
                    if entry.itemType == "d" {
                        NavigationLink(
                            destination: FolderView(currentFolder: entry),
                            label: {
                                HStack {
                                    Image(systemName: "folder")
                                        .foregroundColor(.blue)
                                        .frame(width: 20)
                                    
                                    Text(entry.itemName)
                                        .foregroundColor(.primary)
                                }
                            })
                        /// Plain label for files
                    } else {
                        HStack {
                            Image(systemName: "doc.richtext")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            
                            Text(entry.itemName)
                        }
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
                                destination: FolderView(currentFolder: entry),
                                label: {
                                    VStack {
                                        Image(systemName: "folder")
                                            .font(.system(size: 80))
                                            .frame(width: 100, height: 100)
                                        
                                        Text(entry.itemName)
                                            .foregroundColor(.primary)
                                            .frame(height: 50)
                                    }
                                    .padding()
                                })
                                /// Plain label for files
                            } else {
                                VStack {
                                    Image(systemName: "doc.richtext")
                                        .font(.system(size: 80))
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.blue)
                                    
                                    Text(entry.itemName)
                                }
                                .padding()
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            fetchData()
        }
        .navigationTitle(currentFolderName)
        .toolbar {
            HStack(spacing: 30) {
                Button {
                    // TODO: - NO IMPLEMENTATION YET
                } label: {
                    Image(systemName: "person")
                }
                
                Button {
                    // TODO: - NO IMPLEMENTATION YET
                } label: {
                    Image(systemName: "doc.badge.plus")
                }
                
                Button {
                    // TODO: - NO IMPLEMENTATION YET
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
    
    // FIXME: - JSON fails to deserealize
    /// Fails to deserealize JSON
    func fetchData() {
        let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1wDg1ZvDxA7nFzUJcl8B9Q5JiyIyny_44xwiOqNhYxZw/values/PDFexpert!A2:D38?key=AIzaSyDSE21FBc2H_Z-O8kqsHPAYhmGOCypi2wg")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            print("Data loaded")
            
            let decoder = JSONDecoder()
            print("JSONDecoder initialized")
            
            if let jsonResponse = try? decoder.decode(JSONResponse.self, from: data) {
                DispatchQueue.main.async {
                    entriesToDisplay = responseToEntries(response: jsonResponse.values)
                    print("Loaded \(jsonResponse.values.count) entries")
                }
            } else {
                print("Unable to parse JSON data")
            }
        }.resume()
    }
    
    private func responseToEntries(response: [[String]]) -> Array<Entry> {
        var entries = Array<Entry>()
        
        for element in response {
            entries.append(Entry(id: element[0], parentID: element[1], itemType: element[2], itemName: element[3]))
        }
        
        return entries
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(currentFolder: nil)
    }
}
