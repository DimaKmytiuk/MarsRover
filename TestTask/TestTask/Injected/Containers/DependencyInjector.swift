//
//  DependencyInjector.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 22.01.2024.
//

import SwiftUI
import Combine

struct DIContainer {
    
    let services: ServicesContainer
    
    init(services: DIContainer.ServicesContainer) {
        self.services = services
    }
    
}
