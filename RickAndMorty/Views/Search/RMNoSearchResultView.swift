//
//  RMNoSearchResultView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 1.06.24.
//

import UIKit

class RMNoSearchResultView: UIView {

    private let viewModel = RMNoSearchResultViewViewModel()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemBlue
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        backgroundColor = .systemBackground
        setupViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.text = viewModel.title
        iconView.image = viewModel.image
    }
}

private extension RMNoSearchResultView {
    func setupViews() {
        setupIconView()
        setupLabel()
    }

    func setupIconView() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor ),
            iconView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func setupLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}
