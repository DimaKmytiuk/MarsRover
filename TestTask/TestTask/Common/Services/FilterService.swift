//
//  FilterServiceImpl.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 27.01.2024.
//

import Combine

protocol FilterService {
    var filter: AnyPublisher<[FilterModel], Never> { get }
    
    func saveFilter(_ filter: FilterModel)
    
    func deleteFilter(_ filter: FilterModel)
}


final class FilterServiceImpl: FilterService {
        
    private let repository: FilterLocalRepository
    
    init(repository: FilterLocalRepository) {
        self.repository = repository
    }
    
    var filter: AnyPublisher<[FilterModel], Never> {
        repository.filters
    }
    
    func saveFilter(_ filter: FilterModel) {
        repository.saveFilter(filter)
    }
    
    func deleteFilter(_ filter: FilterModel) {
        repository.deleteFilter(filter)
    }
    
}
