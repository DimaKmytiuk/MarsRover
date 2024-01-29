//
//  BottomSheetViewModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 26.01.2024.
//

import SwiftUI

enum BottomSheet {
    case camera
    case rover
    case date
    
    var title: String {
        switch self {
        case .camera:
            "Camera"
        case .rover:
            "Rover"
        case .date:
            "Date"
        }
    }

}

final class BottomSheetViewModel: ObservableObject {
    
    @Published var selectedDate: Date = Date()
    @Published var filtersArray: [String]?
    @Published var selectedIndex: Int
    @Binding var selectedItem: String
    @State var pickerHeader: BottomSheet
    
    init(array: [String]? = nil,
         title: BottomSheet,
         selectedIndex: Int,
         selectedItem: Binding<String>) {
        self.filtersArray = array
        self.pickerHeader = title
        self.selectedIndex = selectedIndex
        _selectedItem = selectedItem
        
        
    }
}
