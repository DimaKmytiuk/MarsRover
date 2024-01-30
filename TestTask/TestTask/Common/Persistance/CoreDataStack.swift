//
//  CoreDataStack.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 27.01.2024.
//

import Combine
import SwiftUI
import CoreData

protocol PersistentStore {
    var persistentContainer: NSPersistentContainer { get }
}

private struct Constants {
    static let testTaskModelName = "TestTask"
    static let subPathToDB = "db.sql.TestTask"
    static let coreDataStackQueue = DispatchQueue(label: "com.TestTask.CodeDataQueue")
}

struct CoreDataStack: PersistentStore {
    
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    
    private let container: NSPersistentContainer
    
    var persistentContainer: NSPersistentContainer { container }
    
    init(
        directory: FileManager.SearchPathDirectory = .documentDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        version vNumber: UInt
    ) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        
        if let url = version.dbFileURL(directory, domainMask) {
            debugPrint("DB Container URL: \(url)")
            let store = NSPersistentStoreDescription(url: url)
            store.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            container.persistentStoreDescriptions = [store]
        }
        
        Constants.coreDataStackQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        container?.viewContext.configureAsReadOnlyContext()
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }
    
}

// MARK: - Versioning

extension CoreDataStack.Version {
    static var actual: UInt { 0 }
}

extension CoreDataStack {
    
    struct Version {
        private let number: UInt
        
        init(_ number: UInt) {
            self.number = number
        }
        
        var modelName: String { Constants.testTaskModelName }
        
        func dbFileURL(_ directory: FileManager.SearchPathDirectory,
                       _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            let path = FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subPathToDB)
            return path
        }
        
        private var subPathToDB: String { Constants.subPathToDB }
    }
    
}

// MARK: - NSManagedObjectContext Configuration

extension NSManagedObjectContext {
    
    func configureAsReadOnlyContext() {
        automaticallyMergesChangesFromParent = true
        undoManager = nil
        shouldDeleteInaccessibleFaults = true
        mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
}
