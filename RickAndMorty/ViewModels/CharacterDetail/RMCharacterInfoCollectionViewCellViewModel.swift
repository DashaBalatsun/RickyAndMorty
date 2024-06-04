//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 9.05.24.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var iconImage: UIImage? {
            switch self  {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case . episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTtile: String {
            switch self  {
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .created,
                    .location:
                return rawValue.uppercased()
            case . episodeCount:
                return "EPISODE COUNT"
            }
        } 
        
        var tintColor: UIColor {
            switch self  {
            case .status:
                return .systemRed
            case .gender:
                return .systemBlue
            case .type:
                return .systemYellow
            case .species:
                return .systemPink
            case .origin:
                return .systemPurple
            case .created:
                return .systemGreen
            case .location:
                return .systemOrange
            case . episodeCount:
                return .systemMint
            }
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:s.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    private let type: `Type`
    private let value: String
    
    public var title: String {
        type.displayTtile
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var displayValue: String {
        if value .isEmpty { return "None" }
        
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    public var tintColor: UIColor {
        type.tintColor
    }
    
    init(type: `Type`, value: String) {
        self.type = type
        self.value = value
    }
}
