//
//  ContentView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            FolderView(currentFolder: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
