//
//  ServicesContainer.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 22.01.2024.
//

import Foundation

extension DIContainer {
    
    struct ServicesContainer {
        let webService: WebService
        let filterService: FilterService
        
        init(webService: WebService, filterService: FilterService) {
            self.webService = webService
            self.filterService = filterService
        }
    }
}
