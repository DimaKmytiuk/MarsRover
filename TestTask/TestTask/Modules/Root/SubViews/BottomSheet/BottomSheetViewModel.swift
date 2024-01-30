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
    
    @Published var selectedDate: Date
    @Published var itemsArray: [String]?
    @Published var selectedIndex: Int
    @Binding var selectedFilter: FilterModel
    @State var pickerHeader: BottomSheet
    
    init(itemsArray: [String],
         selectedDate: Date,
         title: BottomSheet,
         selectedIndex: Int,
         selectedFilter: Binding<FilterModel>
    ) {
        self.selectedDate = selectedDate
        self.itemsArray = itemsArray
        self.pickerHeader = title
        self.selectedIndex = selectedIndex
        _selectedFilter = selectedFilter
    }
}
