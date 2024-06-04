//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 17.05.24.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    let info: Info
    let results: [RMEpisode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
 
