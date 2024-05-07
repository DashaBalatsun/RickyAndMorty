//
//  RMDetailViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.04.24.
//

import UIKit

final class RMCharacterDetailViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
