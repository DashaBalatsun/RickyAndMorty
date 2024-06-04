//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 15.05.24.
//

import Foundation

// MARK: - Manages in memory session scoped API caches
final class RMAPICacheManager {
    
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setupCache()
    }
    
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCached = cacheDictionary[endpoint],
              let url = url
        else { return }
        let key = url.absoluteString as NSString
        targetCached.setObject(data as NSData, forKey: key)
    }
    
    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCached = cacheDictionary[endpoint],
              let url = url
        else { return nil }
        let key = url.absoluteString as NSString
        return targetCached.object(forKey: key) as? Data
    }
    
    private func setupCache() {
        RMEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
