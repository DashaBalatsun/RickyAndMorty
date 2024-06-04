//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 15.05.24.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject  {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter)
}

class RMEpisodeDetailView: UIView {
    
    public weak var delegate: RMEpisodeDetailViewDelegate?
    
    private var viewModel: RMEpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    private var collectionView: UICollectionView?
    private let spinner = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        spinner.startAnimating()
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(collectionView)
        setpuViews()
    }
    
    required init?(coder: NSCoder) {
         fatalError()
    }
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension RMEpisodeDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else { return 0 }
        let sectionType = sections[section]
        
        switch sectionType {
        case .information(let viewModel):
            return viewModel.count
        case .character(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else { fatalError("No viewModel") }
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information(let viewModel):
            let cellViewModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .character(let viewModel):
            let cellViewModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information:
            break
        case .character:
            guard let character = viewModel.character(at: indexPath.row) else { return }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
        
    }
}

extension RMEpisodeDetailView {
    func setpuViews() {
        setupSpinner()
        setupCollectionView()
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
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else { return createInfoLayout() }
        
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .character:
           return createCollectionLayout()
        }
    }
    
    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .fractionalWidth(1),
                      heightDimension: .fractionalHeight(1)
                     ))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
        let group = NSCollectionLayoutGroup.vertical(layoutSize:
                .init(widthDimension: .fractionalWidth(1),
                      heightDimension: .absolute(80)),
                subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createCollectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .fractionalWidth(0.5),
                      heightDimension: .fractionalHeight(1)
                     ))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                .init(widthDimension: .fractionalWidth(1),
                      heightDimension: .absolute(260)),
                subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
