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
    @Binding var filterModel: FilterModel
    
    private var cancellables = Set<AnyCancellable>()
    let container: DIContainer
    
    init(container: DIContainer,
         filterModel: Binding<FilterModel>) {
        self.container = container
        _filterModel = filterModel

        fetchFilters()
    }
    
    func fetchFilters() {
        container
            .services
            .filterService
            .filter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filter in
                self?.filers = filter
            }
            .store(in: &cancellables)
    }
    
    func removeFilter(filter: FilterModel) {
        container
            .services
            .filterService
            .deleteFilter(filter)
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchFilters()
        }
    }
    
}
