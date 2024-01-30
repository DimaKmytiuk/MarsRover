//
//  FilterLocalRepository.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 27.01.2024.
//

import Combine

protocol FilterLocalRepository {
    var filters: AnyPublisher<[FilterModel], Never> { get }
    
    func saveFilter(_ filter: FilterModel)
    func deleteFilter(_ filter: FilterModel)
}
