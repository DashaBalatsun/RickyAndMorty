//
//  RMEpisodeInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 19.05.24.
//

import Foundation

final class  RMEpisodeInfoCollectionViewCellViewModel {
    
    public let title: String
    public let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
