//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 21.04.24.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMStatus
    let species: String
    let type: String
    let gender: RMGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let episode: [String]
    let image: String
    let url: String
    let created: String
}

struct RMOrigin: Codable {
    let name: String
    let url: String
}

struct RMSingleLocation: Codable {
    let name: String
    let url: String
}

enum RMStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum RMGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case `unknown` = "unknown"
}
