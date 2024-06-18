//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 9.06.24.
//

import Foundation

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodesCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

final class RMSearchResultViewModel {
    
    private var next: String?
    public private(set) var results: RMSearchResultType
    public var showLoadingIndicator: Bool {
        return next != nil
    }
    public private(set) var isLoadingMoreResults = false
    
    init(results: RMSearchResultType, next: String?, isLoadingMoreResults: Bool = false) {
        self.results = results
        self.next = next
        self.isLoadingMoreResults = isLoadingMoreResults
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        isLoadingMoreResults = true
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next
                
                let additionaLocations =  moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .characters(let array):
                    break
                case .episodes(let array):
                    break
                case .locations(let existingResults):
                    newResults = existingResults + additionaLocations
                    strongSelf.results = .locations(newResults)
                }
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    // Notify via callback
                   completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        isLoadingMoreResults = true
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next
                    
                    let additionaResults =  moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionaResults
                    strongSelf.results = .characters(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        // Notify via callback
                       completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next
                    
                    let additionaResults =  moreResults.compactMap({
                        return RMCharacterEpisodesCollectionViewCellViewModel(episodeDataURL: URL(string: $0.url))
                    })
                    
                    
                    var newResults: [RMCharacterEpisodesCollectionViewCellViewModel] = []
                    newResults = existingResults + additionaResults
                    strongSelf.results = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        // Notify via callback
                       completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations(let array):
            break
        }
    }
}
