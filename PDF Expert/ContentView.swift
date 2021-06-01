//
//  ContentView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import SwiftUI

/// Calls FolderView inside NavigationView
struct ContentView: View {
    @State private var entries = [Entry]()
    
    var body: some View {
        NavigationView {
            FolderView(currentFolder: nil, entries: $entries)
                .onAppear { fetchData() }
        }
    }
    
    /// Fetches JSON data from Google Sheet API
    func fetchData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1wDg1ZvDxA7nFzUJcl8B9Q5JiyIyny_44xwiOqNhYxZw/values/PDFexpert!A2:D38?key=AIzaSyDSE21FBc2H_Z-O8kqsHPAYhmGOCypi2wg")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                let decoder = JSONDecoder()
                
                if let jsonResponse = try? decoder.decode(JSONResponse.self, from: data) {
                    DispatchQueue.main.async {
                        entries = responseToEntries(response: jsonResponse.values)
                    }
                } else {
                    print("Unable to parse JSON data")
                }
            }.resume()
        }
    }
    
    /// Converts JSON decoded date into an array of Entry type
    /// - Parameter response: json decoded array of array of strings
    /// - Returns: array of Entry type
    private func responseToEntries(response: [[String]]) -> Array<Entry> {
        var entries = Array<Entry>()
        
        for element in response {
            entries.append(Entry(id: element[0], parentID: element[1], itemType: element[2], itemName: element[3]))
        }
        
        return entries
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
