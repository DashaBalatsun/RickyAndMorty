//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 29.04.24.
//

import UIKit

// MARK: - Show info abou single Character
class RMCharacterDetailViewController: UIViewController {

    private let viewModel: RMCharacterDetailViewModel 
    
    init(viewModel: RMCharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
}
