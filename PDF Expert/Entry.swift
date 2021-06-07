//
//  Entry.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import Foundation

/// JSON response
struct JSONResponse: Codable {
    var values: [[String]]
}

/// A file tree entry – folder (itemType: d) or file (itemType: f)
struct Entry: Codable, Identifiable {
    var id: UUID
    var parentID: UUID?
    var itemType: String
    var itemName: String
    
    init(id: String, parentID: String, itemType: String, itemName: String) {
        self.id = UUID(uuidString: id)!
        
        if parentID != "" {
            self.parentID = UUID(uuidString: parentID)!
        } else {
            self.parentID = nil
        }
        
        self.itemType = itemType
        
        self.itemName = itemName
    }
    
    init(id: UUID, parentID: UUID?, itemType: String, itemName: String) {
        self.id = id
        self.parentID = parentID
        self.itemType = itemType
        self.itemName = itemName
    }
}
