//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 21.04.24.
//

import Foundation

struct RMEpisode: Codable, RMEpisodedatarender {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
