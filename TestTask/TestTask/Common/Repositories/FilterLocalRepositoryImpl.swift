//
//  FilterLocalRepositoryImplementation.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 27.01.2024.
//

import SwiftUI
import Combine
import CoreData

final class FilterLocalRepositoryImpl: FilterLocalRepository {
    
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    var filters: AnyPublisher<[FilterModel], Never> {
        Future<[FilterModel], Never> { [weak self] promise in
            self?.container.performBackgroundTask { privateManagedObjectContext in
                let fetchRequest: NSFetchRequest<FilterEntity> = FilterEntity.fetchRequest()
                fetchRequest.resultType = .managedObjectResultType
                fetchRequest.returnsObjectsAsFaults = false
                
                let managedObject = try? privateManagedObjectContext.fetch(fetchRequest)
                
                let filter = managedObject?.compactMap { filterEntity in
                    let camera = filterEntity.camera
                    let rover = filterEntity.rover
                    let date = filterEntity.date
                    
                    return FilterModel(
                        rover: rover ?? "",
                        camera: camera ?? "",
                        date: date?.toDate() ?? Date()
                    )
                }
                promise(.success(filter ?? []))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveFilter(_ filter: FilterModel) {
        container.performBackgroundTask { privateManagedObjectContext in
            do {
                let fetchRequest: NSFetchRequest<FilterEntity> = FilterEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "camera == %@ AND rover == %@ AND date == %@",
                    filter.camera, filter.rover, filter.date.string(formatter: .dash)
                )
                let existingObjects = try privateManagedObjectContext.fetch(fetchRequest)
                if existingObjects.isEmpty {
                    let newObjectToDb = FilterEntity(context: privateManagedObjectContext)
                    newObjectToDb.camera = filter.camera
                    newObjectToDb.rover = filter.rover
                    newObjectToDb.date = filter.date.string(formatter: .dash)
                    
                    try privateManagedObjectContext.save()
                } else {
                    debugPrint("Filter with the same parameters already exists.")
                }
            } catch { return }  // TODO: Handle Error
        }
    }
    
    func deleteFilter(_ filter: FilterModel) {
        container.performBackgroundTask { privateManagedObjectContext in
            do {
                let fetchRequest = FilterEntity.fetchRequest()
                fetchRequest.resultType = .managedObjectResultType
                fetchRequest.predicate = NSPredicate(
                    format: "date == %@ AND rover == %@ AND camera == %@",
                    filter.date.string(formatter: .dash),
                    filter.rover,
                    filter.camera
                )
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchLimit = 1
                
                do {
                    guard let managedObject = try privateManagedObjectContext.fetch(fetchRequest).first else { return }
                    debugPrint(managedObject)
                    privateManagedObjectContext.delete(managedObject)
                    
                    try privateManagedObjectContext.save()
                } catch { return } // TODO: Handle Error
            }
        }
    }
    
}
