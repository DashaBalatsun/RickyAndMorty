//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 23.04.24.
//

import Foundation

// MARK: - API Endpoint
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    case character
    case location
    case episode
}
