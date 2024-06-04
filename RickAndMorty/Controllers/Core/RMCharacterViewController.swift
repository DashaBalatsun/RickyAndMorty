//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 21.04.24.
//

import UIKit

// MARK: - Controller to show and search Characters
final class RMCharacterViewController: UIViewController {
    
    private let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        characterListView.delegate = self
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupViews()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - RMCharacterListViewDelegate
extension RMCharacterViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RMCharacterViewController {
    func setupViews() {
        setupCharacterListView()
    }
    
    func setupCharacterListView() {
        view.addSubview(characterListView)
        
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
