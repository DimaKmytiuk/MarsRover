//
//  APIEndpoint.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 23.01.2024.
//

import SwiftUI
import Combine

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

 enum HTTPMethod: String {
    case get = "GET"
}

fileprivate enum APIError: Error {
    case invalidResponse
    case invalidData
}

enum MarsRoverEndpoint: APIEndpoint {
    case getRovers(earthDate: String, apiKey: String, page: Int)

    var baseURL: URL {
        guard let url = URL(string: "https://api.nasa.gov") else {
            fatalError("Failed to create baseURL.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getRovers:
            return "/mars-photos/api/v1/rovers/curiosity/photos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRovers:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getRovers(let earthDate, let apiKey, let page):
            return ["earth_date": earthDate, "api_key": apiKey, "page": page]
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}

final class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
        var components = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: true)
        components?.path = endpoint.path
        
        if let parameters = endpoint.parameters {
            components?.queryItems = parameters.map{ key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = components?.url else {
            let error = URLError(.badURL)
            return Fail<T, Error>(error: error).eraseToAnyPublisher()
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
            
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
