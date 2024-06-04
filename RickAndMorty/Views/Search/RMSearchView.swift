//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 1.06.24.
//

import UIKit

final class RMSearchView: UIView {
    
    private let viewModel: RMSearchViewViewModel
    private let noResultsView = RMNoSearchResultView()
    
    
     // MARK: - Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - CollectionView
extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension RMSearchView {
    func setupViews() {
        setupNoResultsView()
    }

    func setupNoResultsView() {
        addSubview(noResultsView)
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

