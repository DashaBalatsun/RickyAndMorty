//
//  RMCharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 9.05.24.
//

import UIKit

protocol RMEpisodedatarender {
    var episode: String { get }
    var name: String { get }
    var air_date: String { get }
}

final class  RMCharacterEpisodesCollectionViewCellViewModel: Hashable, Equatable {
    
    private var isFetching = false
    private let episodeDataURL: URL?
    private var dataBlock: ((RMEpisodedatarender) -> Void)?
    
    public let borderColor: UIColor
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    init(episodeDataURL: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataURL = episodeDataURL
        self.borderColor = borderColor
    }
    
    public func registerForData(_ block: @escaping (RMEpisodedatarender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataURL, let request = RMRequest(url: url) else { return }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self ) { [weak self]  result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure ))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataURL?.absoluteString ?? "")
    }
    
    static func == (lhs: RMCharacterEpisodesCollectionViewCellViewModel, rhs: RMCharacterEpisodesCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

