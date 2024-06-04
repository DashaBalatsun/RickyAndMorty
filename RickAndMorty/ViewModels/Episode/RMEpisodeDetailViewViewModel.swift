 //
//  RMEpisodDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 15.05.24.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetail()
}

final class RMEpisodeDetailViewViewModel {
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    private let endpointUrl: URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetail()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []

    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.characters[index]
    }
    
    // MARK: - Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url)
        else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { [weak self] result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var createdString = episode.created
        
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .character(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name ,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image))
            }))
        ]
    }
}
