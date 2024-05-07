//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 25.04.24.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    let info: Info
    let results: [RMCharacter]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
