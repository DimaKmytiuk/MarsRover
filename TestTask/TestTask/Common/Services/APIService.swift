//
//  APIService.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Combine

protocol APIService {
    func getPhotos(apiKey: String, earthDate: String, page: Int) -> AnyPublisher<PhotoArrayDTO, Error>
}

final class APIServiceImpl: APIService {
    
    let apiClient = URLSessionAPIClient<MarsRoverEndpoint>()
    
    func getPhotos(apiKey: String, earthDate: String, page: Int) -> AnyPublisher<PhotoArrayDTO, Error> {
        return apiClient.request(.getRovers(earthDate: earthDate, apiKey: apiKey, page: page))
    }

}

