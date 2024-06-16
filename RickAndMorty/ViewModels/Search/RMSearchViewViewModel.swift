//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 1.06.24.
//

import Foundation

final class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    
    private var optionMapUpdateblock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchResultHandler: ((RMSearchResultViewModel)-> Void)?
    private var noResultsHandler: (()-> Void)?
    private var searchText = ""
    private var searchResultModel: Codable?
     
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value 
        let tuple = (option, value)
        optionMapUpdateblock?(tuple)
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateblock = block
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel)-> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping ()-> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        guard searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        // MARK - Build arguments
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
        // MARK - Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key:RMSearchInputViewViewModel.DynamicOption = element.key
            let value:String = element.value
            return URLQueryItem(name: key.queryArgument, value: value )
        }))
        
        // MARK - Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
      
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }
        
    }
    
    private func makeSearchAPICall<T:Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResult(model: model)
            case .failure(let error):
                self?.handleNoResults()
            }
        }
    }
    
    private func processSearchResult(model: Codable) {
        var resultsVM: RMSearchResultType?
        var nextURL: String?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
            nextURL = characterResults.info.next
        } else  if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            print("\(resultsVM)")
            nextURL = locationsResults.info.next
        } else  if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodesCollectionViewCellViewModel(episodeDataURL: URL(string: $0.url))
            }))
            nextURL = episodesResults.info.next
        }
        
        if let results = resultsVM {
            self.searchResultModel = model
            let vm = RMSearchResultViewModel(results: results, next: nextURL)
            self.searchResultHandler?(vm)
        } else {
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        print("No results here")
        noResultsHandler?()
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}
