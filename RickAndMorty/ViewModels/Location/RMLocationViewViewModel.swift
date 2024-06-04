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
    
    private var hasMoreResults: Bool {
        return false
    }
    
    init() {}
    
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
}
