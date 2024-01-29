//
//  HistoryViewModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 27.01.2024.
//

import SwiftUI
import Combine

final class HistoryViewModel: ObservableObject {
    
    @Published var filers: [FilterModel] = []
    @Binding var selectedDate: String
    @Binding var selectedRover: String
    @Binding var selectedCamera: String
    
    private var cancellables = Set<AnyCancellable>()

    let container: DIContainer
    
    init(container: DIContainer,
         selectedDate: Binding<String>,
         selectedRover: Binding<String>,
         selectedCamera: Binding<String>
    ) {
        self.container = container
        _selectedDate = selectedDate
        _selectedRover = selectedRover
        _selectedCamera = selectedCamera
        fetchFilters()
    }
    
    func fetchFilters() {
        container
            .services
            .filterService
            .filter
            .receive(on: DispatchQueue.main)
            .sink { filter in
                self.filers = filter
                print(self.filers)
            }
            .store(in: &cancellables)
    }
    
    func removeFilter(filter: FilterModel) {
        container
            .services
            .filterService
            .deleteFilter(filter)
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.00) { [weak self] in
            self?.fetchFilters()
        }
    }
}
