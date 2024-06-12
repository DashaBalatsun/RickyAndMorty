//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 9.06.24.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodesCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
