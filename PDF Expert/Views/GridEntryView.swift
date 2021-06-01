//
//  GridEntryView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 01.06.2021.
//

import SwiftUI

struct GridEntryView: View {
    var name: String
    var imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 80))
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(name)
                .foregroundColor(.primary)
                .frame(height: 50)
        }
        .padding()
    }
}

struct GridEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GridEntryView(name: "folder", imageName: "folder")
    }
}
