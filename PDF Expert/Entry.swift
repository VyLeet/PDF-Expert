//
//  Entry.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 31.05.2021.
//

import Foundation

/// JSON response from third-party spreadsheet parser
struct JSONResponse: Codable {
    var values: [[String]]
}

/// A file tree entry – folder (itemType: d) or file (itemType: f)
struct Entry: Codable, Identifiable {
    var id: UUID
    var parentID: UUID?
    var itemType: String
    var itemName: String
    
    /// For test purposes only
    fileprivate init(id: UUID, parentID: UUID?, itemType: String, itemName: String) {
        self.id = id
        self.parentID = parentID
        self.itemType = itemType
        self.itemName = itemName
    }
    
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
}

//// For test purposes only
//let testEntries: Array<Entry> = [
//    Entry(id: UUID(uuidString: "A2AB993B-9D12-403F-A3B4-A77EEDE17521")!, parentID: UUID(uuidString:"55382859-D5F5-4A12-8AD6-308389929F56"), itemType: "f", itemName: "вступление.docx"),
//    Entry(id: UUID(uuidString: "4532D46B-D57B-452C-8363-563FBACBA593")!, parentID: UUID(uuidString:"55382859-D5F5-4A12-8AD6-308389929F56"), itemType: "f", itemName: "presentation.ppt"),
//    Entry(id: UUID(uuidString: "A249EEF7-9B38-4D78-9FB6-F342DA758A6F")!, parentID: UUID(uuidString:"1C4A5B0D-C2DB-43CB-A716-EDF7E091FA4F"), itemType: "f", itemName: "75595287_586790498778990_5946898716899147776_n"),
//    Entry(id: UUID(uuidString: "FD97A0A1-9DFE-4A9C-A9BB-630C31F2B608")!, parentID: UUID(uuidString:"55382859-D5F5-4A12-8AD6-308389929F56"), itemType: "f", itemName: "diplom.pdf"),
//    Entry(id: UUID(uuidString: "841C2867-2341-44AD-9145-971125F54E44")!, parentID: UUID(uuidString:"55382859-D5F5-4A12-8AD6-308389929F56"), itemType: "d", itemName: "sources"),
//    Entry(id: UUID(uuidString: "38F1F447-F897-4260-B6AC-17DB78CC0C8E")!, parentID: UUID(uuidString:"841C2867-2341-44AD-9145-971125F54E44"), itemType: "f", itemName: "approximation.py"),
//    Entry(id: UUID(uuidString: "1C4A5B0D-C2DB-43CB-A716-EDF7E091FA4F")!, parentID: nil, itemType: "d", itemName: "Photos"),
//    Entry(id: UUID(uuidString: "1F800A79-07F2-4D45-81F5-3E1676916AAB")!, parentID: UUID(uuidString: "55382859-D5F5-4A12-8AD6-308389929F56"), itemType: "f", itemName: "diplom.tex"),
//    Entry(id: UUID(uuidString: "A47E4DA6-9DD4-415D-BA5C-4D051B95CA9B")!, parentID: nil, itemType: "f", itemName: "война и мир.epub"),
//    Entry(id: UUID(uuidString: "B77B4F7B-4DB4-450D-B894-57DB52C1CD52")!, parentID: nil, itemType: "d", itemName: "Internship"),
//    Entry(id: UUID(uuidString: "667C4793-F220-4B83-8A0F-1B6D308B4E98")!, parentID: UUID(uuidString:"B77B4F7B-4DB4-450D-B894-57DB52C1CD52"), itemType: "f", itemName: "assignment.doc"),
//    Entry(id: UUID(uuidString: "E6B58A5D-3A3A-4A58-ACE8-23464E555576")!, parentID: UUID(uuidString:"B77B4F7B-4DB4-450D-B894-57DB52C1CD52"), itemType: "f", itemName: "intro and description.docx"),
//    Entry(id: UUID(uuidString: "026B3864-7ABA-4A61-8117-700CA704FE83")!, parentID: UUID(uuidString:"841C2867-2341-44AD-9145-971125F54E44"), itemType: "f", itemName: "arima.r"),
//
//    Entry(id: UUID(uuidString: "0B0B5421-87BC-4BC8-B933-CE9155C65B4C")!, parentID: UUID(uuidString:"1C4A5B0D-C2DB-43CB-A716-EDF7E091FA4F"), itemType: "d", itemName: "75595287_586790498778990_5946898716899147776_n"),
//    Entry(id: UUID(uuidString: "DB5CBFD0-8A96-4D1E-B2A7-09419BDC2198")!, parentID: nil, itemType: "d", itemName: "Docs"),
//    Entry(id: UUID(uuidString: "00A8E613-86D0-4559-A3A1-1F18432389DA")!, parentID: UUID(uuidString:"DB5CBFD0-8A96-4D1E-B2A7-09419BDC2198"), itemType: "f", itemName: "паспорт.pdf"),
//]
