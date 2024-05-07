//
//  RMService.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 23.04.24.
//

import Foundation

// MARK: - Primary API service object to get Rick and Morty dara
final class RMService {
    // MARK: - Shared singleton instance
    static let shared = RMService()
    
    // MARK: - Private init
    private init() {}
    
    // MARK: - Send Rick and Morty API Call(Parameters: -request: Request instance, completion: Callback with data or error)
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T,Error>) -> Void) {
            
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) {data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToReturnData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    // MARK: - Private
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}

enum RMServiceError: Error {
    case failedToCreateRequest
    case failedToReturnData
}

