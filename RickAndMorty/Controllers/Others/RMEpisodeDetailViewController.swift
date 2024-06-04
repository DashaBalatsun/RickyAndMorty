//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 14.05.24.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    
    private let viewModel: RMEpisodeDetailViewViewModel
    private let episodeDetailView = RMEpisodeDetailView()
    
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemBackground
        setupViews()
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShape))
        episodeDetailView.delegate = self
    }
    
    @objc func didTapShape() {
        
    }
}

extension RMEpisodeDetailViewController {
    func setupViews() {
        setupEpisodeView()
    }
    
    func setupEpisodeView() {
        view.addSubview(episodeDetailView)
        
        NSLayoutConstraint.activate([
            episodeDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMEpisodeDetailViewController: RMEpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetail() {
        episodeDetailView.configure(with: viewModel)
    }
}

extension RMEpisodeDetailViewController: RMEpisodeDetailViewDelegate {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
