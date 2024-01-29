//
//  AppEnvironment.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 21.01.2024.
//

import Foundation
import CoreData

// MARK: AppEnvitonment

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let localRepositories = configureRepositories(persistentContainer: persistentStore.persistentContainer)
        let services = configuratedServices(localRepositories: localRepositories)
        let diContainer = DIContainer(services: services)
        
        return AppEnvironment(container: diContainer)
    }
}

extension AppEnvironment {
    private static func configuratedServices(localRepositories: DIContainer.LocalRepositories) -> DIContainer.ServicesContainer {
        let apiService: APIServiceImpl = APIServiceImpl()
        let filterService: FilterService = FilterServiceImpl(repository: localRepositories.filterLocalRepository)
        
        return .init(APIService: apiService, filterService: filterService)
    }
}

extension AppEnvironment {
    private static func configureRepositories(persistentContainer: NSPersistentContainer) -> DIContainer.LocalRepositories {
        let filterLocalRepository: FilterLocalRepository = FilterLocalRepositoryImpl(container: persistentContainer)
        
        return .init(filterLocalRepository: filterLocalRepository)
    }
}

extension DIContainer {
    struct LocalRepositories {
        let filterLocalRepository: FilterLocalRepository
    }
}
