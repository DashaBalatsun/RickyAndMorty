//
//  RMCharacterDetailView .swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.04.24.
//

import UIKit

final class RMCharacterDetailView: UIView {
    
    private var viewModel: RMCharacterDetailViewModel
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    public var collectionView: UICollectionView?
    
    init(frame: CGRect, viewModel: RMCharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(collectionView)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifer)
        collectionView.register(RMCharacterInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifer)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionType = viewModel.sections
        switch sectionType[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        }
    }
}

extension RMCharacterDetailView {
    private func setupViews() {
        setupSpinner()
        setupColectionView()
    }
    
    func setupSpinner() {
        addSubview(spinner)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupColectionView() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
