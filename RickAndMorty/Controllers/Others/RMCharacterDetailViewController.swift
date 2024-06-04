//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.04.24.
//

import UIKit

// MARK: - Show info abou single Character
class RMCharacterDetailViewController: UIViewController {

    private let viewModel: RMCharacterDetailViewModel 
    private let  detailView: RMCharacterDetailView
    
    // MARK: - Init
    init(viewModel: RMCharacterDetailViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        setupDetailView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShape)
        )
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    @objc private func didTapShape() {
        
    }
}

extension RMCharacterDetailViewController {
    func setupDetailView() {
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
}

// MARK: - CollectionView
extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else { fatalError() }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModels):
           guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else { fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
           guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else { fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .episodes:
            let episodeUrl = self.viewModel.episodes
            let selection = episodeUrl[indexPath.row]
            let vc = RMEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
