//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 27.05.24.
//

import Foundation

protocol RMLocationViewViewModelProtocol: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelProtocol?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations = false
    
    private var hasMoreResults: Bool {
        return false
    }
    
    private var didFinishPaginition: (() -> Void)?
    
    init() {}
    
    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPaginition = block
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >=  0 else { return nil }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequests, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.apiInfo = success.info
                self?.locations = success.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    // Paginate if additional locations are needed
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }
        isLoadingMoreLocations = true
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    // Notify via callback
                    strongSelf.didFinishPaginition?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
            }
        }
    }
}
