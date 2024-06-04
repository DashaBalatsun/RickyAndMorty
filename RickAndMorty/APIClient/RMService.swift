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
    
    private let cacheManager = RMAPICacheManager()
    
    // MARK: - Private init
    private init() {}
    
    // MARK: - Send Rick and Morty API Call(Parameters: -request: Request instance, completion: Callback with data or error)
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T,Error>) -> Void) {
            if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
                do {
                    let result = try JSONDecoder().decode(type.self, from: cachedData)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
               return
            }
            
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToReturnData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                    self?.cacheManager.setCache(for: request.endpoint , url: request.url, data: data)
                }  catch {
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

