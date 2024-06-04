//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.05.24.
//

import UIKit

class RMLocationDetailViewController: UIViewController {
    
    private let viewModel: RMLocationDetailViewViewModel
    private let locationDetailView = RMLocationDetailView()
    
    // MARK: - Init
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        viewModel.fetchLocationData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShape))
        locationDetailView.delegate = self
        setupViews()
    }
    
    @objc func didTapShape() {
        
    }
}

extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetail() {
        locationDetailView.configure(with: viewModel)
    }
}

extension RMLocationDetailViewController: RMELocationlDetailViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMLocationDetailViewController {
    func setupViews() {
        setupLocationView()
    }
    
    func setupLocationView() {
        view.addSubview(locationDetailView)
        
        NSLayoutConstraint.activate([
            locationDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
