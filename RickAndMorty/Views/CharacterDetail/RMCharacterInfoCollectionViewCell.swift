//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 9.05.24.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifer = "RMCharacterInfoCollectionViewCell"
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "globe.americas")
        return icon
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
      
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = viewModel.tintColor
        titleLabel.textColor = viewModel.tintColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = nil
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = .label
        titleLabel.textColor = .label
    }
}


extension RMCharacterInfoCollectionViewCell {
    func setupViews() {
        setupTitleContainerView()
        setupImageView()
        setupTitleLable()
        setupValueLable()
    }
    
    func setupImageView() {
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:35)
        ])
    }
    
    func setupTitleContainerView() {
        contentView.addSubview(titleContainerView)
        titleContainerView.backgroundColor = .tertiarySystemFill
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33)
        ])
    }
    
    func setupTitleLable() {
        titleContainerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor)
        ])
    }
    
    func setupValueLable() {
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            valueLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
    }
    
}
