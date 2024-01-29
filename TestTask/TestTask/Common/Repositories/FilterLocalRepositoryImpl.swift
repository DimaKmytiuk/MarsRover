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
    
    private var container: NSPersistentContainer
    
    private let cancellables: Set<AnyCancellable> = []
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    var filters: AnyPublisher<[FilterModel], Never> {
        
        return Future<[FilterModel], Never> { promise in
            self.container.performBackgroundTask { privateManagedObjectContext in
                let fetchRequest: NSFetchRequest<FilterEntity> = FilterEntity.fetchRequest()
                fetchRequest.resultType = .managedObjectResultType
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let managedObject = try privateManagedObjectContext.fetch(fetchRequest)
                    
                    let filter = managedObject.map { filterEntity in
                        let camera = filterEntity.camera
                        let rover = filterEntity.rover
                        let date = filterEntity.date
                        return FilterModel(rover: rover ?? "", camera: camera ?? "", date: date ?? "")
                    }
                    
                    promise(.success(filter))
                } catch { return }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func saveFilter(_ filter: FilterModel) {
        
        container.performBackgroundTask { privateManagedObjectContext in
            do {
                let fetchRequest: NSFetchRequest<FilterEntity> = FilterEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "camera == %@ AND rover == %@ AND date == %@",
                    filter.camera, filter.rover, filter.date
                )
                let existingObjects = try privateManagedObjectContext.fetch(fetchRequest)
                if existingObjects.isEmpty {
                    let newObjectToDb = FilterEntity(context: privateManagedObjectContext)
                    newObjectToDb.camera = filter.camera
                    newObjectToDb.rover = filter.rover
                    newObjectToDb.date = filter.date
                    
                    try privateManagedObjectContext.save()
                } else {
                    debugPrint("Filter with the same parameters already exists.")
                }
            } catch { return }
        }
    }
    
    func deleteFilter(_ filter: FilterModel) {
        
        container.performBackgroundTask { privateManagedObjectContext in
            do {
                let fetchRequest = FilterEntity.fetchRequest()
                fetchRequest.resultType = .managedObjectResultType
                fetchRequest.predicate = .init(format: "date == %@ AND rover == %@ AND camera == %@",
                                               filter.date,
                                               filter.rover,
                                               filter.camera
                )
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchLimit = 1
                
                do {
                    guard let managedObject = try privateManagedObjectContext.fetch(fetchRequest).first else { return }
                    print(managedObject)
                    privateManagedObjectContext.delete(managedObject)
                    try privateManagedObjectContext.save()
                } catch { return }
            }
        }
    }

}
