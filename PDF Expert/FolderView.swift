//
//  FolderView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import SwiftUI

struct FolderView: View {
    var currentFolder: Entry?
    
    @AppStorage("isTableLayout") private var isTableLayout = true
    
    @State private var currentFolderName = "Main Folder"
    @State private var entriesToDisplay = Array<Entry>()
    @State private var fileNames = ["File1", "File2", "File3"]
    @State private var testDataPresented = true
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(currentFolder: Entry?) {
        self.currentFolder = currentFolder
        
        _entriesToDisplay = State(wrappedValue: testEntries)
        
        if currentFolder != nil {
            _currentFolderName = State(wrappedValue: currentFolder!.itemName)
        }
    }
    
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
            if isTableLayout {
                List(correctEntries) { entry in
                    if entry.itemType == "d" {
                        NavigationLink(
                            destination: FolderView(currentFolder: entry),
                            label: {
                                HStack {
                                    Image(systemName: entry.itemType == "d" ? "folder" : "doc.richtext")
                                        .foregroundColor(.blue)
                                        .frame(width: 20)
                                    
                                    Text(entry.itemName)
                                        .foregroundColor(.primary)
                                }
                            })
                    } else {
                        HStack {
                            Image(systemName: entry.itemType == "d" ? "folder" : "doc.richtext")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            
                            Text(entry.itemName)
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(correctEntries) { entry in
                            if entry.itemType == "d" {
                            NavigationLink(
                                destination: FolderView(currentFolder: entry),
                                label: {
                                    VStack {
                                        Image(systemName: entry.itemType == "d" ? "folder" : "doc.richtext")
                                            .font(.system(size: 80))
                                            .frame(width: 100, height: 100)
                                        
                                        Text(entry.itemName)
                                            .foregroundColor(.primary)
                                            .frame(height: 50)
                                    }
                                    .padding()
                                })
                            } else {
                                VStack {
                                    Image(systemName: entry.itemType == "d" ? "folder" : "doc.richtext")
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
        .onAppear { fetchData() }
        .navigationTitle(currentFolderName)
        .toolbar {
            HStack(spacing: 30) {
                Button {
                    testDataPresented.toggle()
                    DispatchQueue.global(qos: .userInitiated).async {
                        if testDataPresented {
                            entriesToDisplay = testEntries
                        } else {
                            entriesToDisplay = []
                            fetchData()
                        }
                    }
                } label: {
                    Text(testDataPresented ? "Test data" : "Fetched data 😭")
                }
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
    
    func fetchData() {
        let url = URL(string: "https://v1.nocodeapi.com/soloway/google_sheets/RGsuPrZrORUtxftk?tabId=PDFexpert")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            let decoder = JSONDecoder()
            
            if let jsonResponse = try? decoder.decode(JSONResponse.self, from: data) {
                DispatchQueue.main.async {
                    let dict = jsonResponse.data
                    var entryArray = Array<Entry>()
                    for (_, value) in dict {
                        entryArray.append(value)
                    }
                    
                    entriesToDisplay = entryArray
                    print("Loaded \(entryArray.count) entries")
                }
            } else {
                print("Unable to parse JSON data")
            }
        }.resume()
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(currentFolder: nil)
    }
}
