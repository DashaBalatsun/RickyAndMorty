//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 27.05.24.
//

import UIKit

protocol RMLocationViewDelegate: AnyObject {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation)
}

final class RMLocationView: UIView {
    
    public weak var delegate: RMLocationViewDelegate?
    
    private var viewModel: RMLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.reloadData()
            tableView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.alpha = 0
        table.isHidden = true
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        return table
    }()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
// MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        spinner.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
    }
}

extension RMLocationView {
    func setupViews() {
        setupTableViewl()
        setupSpinner()
    }

    func setupTableViewl() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
         
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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
}

extension RMLocationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else { fatalError() }
        guard let cellViewModels = viewModel?.cellViewModels else { fatalError() }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel?.location(at: indexPath.row) else { return }
        delegate?.rmLocationView(self, didSelect: viewModel)
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cellViewModels.count ?? 0
    }
}
