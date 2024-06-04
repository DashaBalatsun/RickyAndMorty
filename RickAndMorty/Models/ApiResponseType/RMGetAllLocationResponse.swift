//
//  RMGetAllLocationResponse.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 28.05.24.
//


import Foundation

struct RMGetAllLocationsResponse: Codable {
    let info: Info
    let results: [RMLocation]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
 
