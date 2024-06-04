//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 23.04.24.
//

import Foundation

// MARK: - single API call
final class RMRequest {
    
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    let endpoint: RMEndpoint
    
    private let pathComponents:  [String]
    private let queryParameters: [URLQueryItem]
    public let httpMethod = "GET"
    
    // MARK: - Constructed url for the api request in string format
    private var urlString: String {
        var baseUrl = Constants.baseUrl
        baseUrl += "/"
        baseUrl += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                baseUrl += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            baseUrl += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            baseUrl += argumentString
        }
        return baseUrl
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                var pathComponents: [String] = []
                let endpointString = components[0]
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?" )
            if !components.isEmpty {
                let endpointString = components[0]
                let queryItemString = components[1]
                let queryItem: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItem)
                    return
                }
            }
        }
        return nil
    }
}
extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listEpisodesRequests = RMRequest(endpoint: .episode)
    static let listLocationsRequests = RMRequest(endpoint: .location)
}
