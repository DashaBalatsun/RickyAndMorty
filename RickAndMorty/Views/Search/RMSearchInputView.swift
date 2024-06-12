//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 1.06.24.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didChangeSearchText text: String)
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

class RMSearchInputView: UIView {

    weak var delegate: RMSearchInputViewDelegate?
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionSelectionView(options: options)
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBAr = UISearchBar()
        searchBAr.placeholder = "Search"
        return searchBAr
    }()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with viewModel: RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceHolderText
        self.viewModel = viewModel
    }
    
    public func  createOptionSelectionView(options: [RMSearchInputViewViewModel.DynamicOption]) {
        setupStackView()
        for x in 0..<options.count {
            let option = options[x]
            let button = createSearchButton(option: option, tag: x)
        }
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        guard let buttons = stackView.arrangedSubviews as? [UIButton],
              let options = viewModel?.options,
              let index = options.firstIndex(of: option)
        else { return }
        buttons[index].setAttributedTitle(NSAttributedString(
            string: value.uppercased(),
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.link
            ]
        ), for: .normal)
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else { return }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
}

private extension RMSearchInputView {
    func setupViews() {
        setupSearchBar()
    }

    func setupSearchBar() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor )
        ])
    }
    
    func createSearchButton(option: RMSearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let searchButton = UIButton()
        searchButton.backgroundColor = .secondarySystemFill
        searchButton.setAttributedTitle(NSAttributedString(
            string: option.rawValue,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.label
            ]
        ), for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.tag = tag
        searchButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        searchButton.layer.cornerRadius = 6
        stackView.addArrangedSubview(searchButton)
        return searchButton
    }
}

extension RMSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
    }
}
