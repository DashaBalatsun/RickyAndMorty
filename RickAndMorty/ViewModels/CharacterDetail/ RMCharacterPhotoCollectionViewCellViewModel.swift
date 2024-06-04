//
//   RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 9.05.24.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return  }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
