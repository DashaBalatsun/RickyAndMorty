//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.05.24.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "RMLocationTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dimensionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15 , weight: .light)
        label.textColor = .secondaryLabel 
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews() 
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }

    public func configure(with viewModel: RMLocationTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        typeLabel.text = viewModel.type
        dimensionLabel.text = viewModel.dimension
    }
}

extension RMLocationTableViewCell {
    func setupViews() {
        setupNameLabel()
        setupTypeLabel()
        setupDimensionLabel()
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func setupTypeLabel() {
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func setupDimensionLabel() {
        contentView.addSubview(dimensionLabel)
        dimensionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            dimensionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dimensionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

