//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 26.04.24.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    public let characterName: String
    private let characterStatus: RMStatus
    private let characterImageUrl: URL?
    
    // MARK: - Init
    init(characterName: String, characterStatus: RMStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.rawValue.capitalized)"
    }
    
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else { return completion(.failure(URLError(.badURL)))}
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
       
    // MARK: - Hasable
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
