//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 15.05.24.
//

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeistView(_ characterListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode )
}

// MARK: - View that handles showing list of characters, loader, ect.
final class  RMEpisodeListView: UIView {
    
    public weak var delegate: RMEpisodeListViewDelegate?
 
    private let viewModel = RMEpisodeViewViewModel()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let colectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colectionView.isHidden = true
        colectionView.alpha = 0
        colectionView.translatesAutoresizingMaskIntoConstraints = false
        colectionView.register(RMCharacterEpisodeCollectionViewCell .self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        colectionView.register(RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )
        return colectionView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

extension  RMEpisodeListView {
    func setupViews() {
        setupColectionView()
        setupSpinner()
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
        addSubview(collectionView)
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension  RMEpisodeListView: RMEpisodeListViewModelDelegate {
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeistView(self, didSelectEpisode: episode)
    }
    
    func didLoadInitialEpisodes() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
}
