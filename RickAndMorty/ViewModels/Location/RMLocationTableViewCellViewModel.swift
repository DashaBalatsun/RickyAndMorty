//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.05.24.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable, Equatable  {
    
    private var location: RMLocation
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type: " + location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    init(location: RMLocation) {
        self.location = location
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
        hasher.combine(location.id)
    }
}
