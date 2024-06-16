//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 16.06.24.
//

import UIKit

final class RMTableLoadingFooterView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false 
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RMTableLoadingFooterView {
    func setupViews() {
        setupSpinner()
    }
    
    func setupSpinner() {
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 55),
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 100),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])
    }
}
