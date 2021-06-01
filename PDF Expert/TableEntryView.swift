//
//  TableEntryView.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 01.06.2021.
//

import SwiftUI

struct TableEntryView: View {
    var name: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(name)
                .foregroundColor(.primary)
        }
    }
}

struct TableEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TableEntryView(name: "Photos", imageName: "folder")
    }
}
