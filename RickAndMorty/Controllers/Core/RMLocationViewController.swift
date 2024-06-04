//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 21.04.24.
//

import UIKit

// MARK: - Controller to show and search Locations
final class RMLocationViewController: UIViewController {

    private let primaryView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        setupViews()
        viewModel.delegate = self
        viewModel.fetchLocations()
        primaryView.delegate = self
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMLocationViewController {
    func setupViews() {
        setupLocationListView()
    }
    
    func setupLocationListView() {
        view.addSubview(primaryView)
        
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}

extension RMLocationViewController: RMLocationViewViewModelProtocol {
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}

extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
