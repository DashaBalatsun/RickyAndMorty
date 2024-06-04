//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 21.04.24.
//

import UIKit

// MARK: - Controller to show and search Episodes
final class RMEpisodeViewController: UIViewController {
    
    private let episodeListView = RMEpisodeListView()
    
    override func viewDidLoad() {
        episodeListView.delegate = self
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setupViews()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - RMEpisodeListViewDelegate
extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeistView(_ characterListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RMEpisodeViewController {
    func setupViews() {
        setupEpisodeListView()
    }
    
    func setupEpisodeListView() {
        view.addSubview(episodeListView)
        
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}

