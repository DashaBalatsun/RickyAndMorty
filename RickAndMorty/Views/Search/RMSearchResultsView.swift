//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 12.06.24.
//

import UIKit

// MARK: - Showx search results UI
final class RMSearchResultsView: UIView {

    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.proccessViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
    
    private func proccessViewModel() {
        guard let viewModel = viewModel else { return }
        
        switch viewModel {
        case .characters(let viewModels):
            createCollectionView()
        case .episodes(let viewModels):
            createCollectionView()
        case .locations(let viewModels):
            createTableView()
        }
    }
    
    private func createCollectionView() {
        
    }
    
    private func createTableView() {
        tableView.isHidden = false
    }
}

private extension RMSearchResultsView {
    func setupViews() {
        setupTableView()
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
