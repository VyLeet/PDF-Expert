//
//  AddButton.swift
//  PDF Expert
//
//  Created by Nazariy Vysokinskyi on 02.06.2021.
//

import SwiftUI

/// Button controlling presence of NewEntryView
struct AddButton: View {
    var buttonType: EntryType
    
    @Binding var newEntryBeingEntered: Bool
    @Binding var newEntryType: EntryType?
    
    var body: some View {
        Button {
            if newEntryType == buttonType {
                withAnimation {
                    newEntryBeingEntered = false
                }
                newEntryType = nil
            } else {
                withAnimation {
                    newEntryBeingEntered = true
                }
                newEntryType = buttonType
            }
        } label: {
            Image(systemName: buttonType == .d ? "folder.badge.plus" : "doc.badge.plus")
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(buttonType: .d, newEntryBeingEntered: .constant(true), newEntryType: .constant(.d))
    }
}
