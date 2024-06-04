//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 19.05.24.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.valueLabel.text = nil
    }
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.valueLabel.text = viewModel.value
    }
}

extension RMEpisodeInfoCollectionViewCell {
    func setupViews() {
        setupTitleLabel()
        setupValueLabel()
        setupLayer()
    }
       
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
        ])
    }
    
    func setupValueLabel() {
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47)
        ])
    }
    
    func setupLayer() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
}

