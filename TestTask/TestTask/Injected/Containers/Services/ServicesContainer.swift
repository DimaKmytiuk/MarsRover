//
//  ServicesContainer.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 22.01.2024.
//

import Foundation

extension DIContainer {
    
    struct ServicesContainer {
        let APIService: APIService
        let filterService: FilterService
        
        init(APIService: APIService,
             filterService: FilterService) {
            self.APIService = APIService
            self.filterService = filterService
        }
    }
}
