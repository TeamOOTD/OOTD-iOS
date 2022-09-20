//
//  TodoBottomSheetSection.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import UIKit

import OOTD_UIKit

enum TodoBottomSheetSection: CaseIterable {
    case priority
    case todo
    case input
    case project
}

extension TodoBottomSheetSection {
    
    var cell: (className: AnyClass, cellId: String) {
        switch self {
        case .priority:  return (PriorityCell.self, PriorityCell.reuseIdentifier)
        case .todo:      return (ODSBasicBlockCell.self, ODSBasicBlockCell.reuseIdentifier)
        case .input:     return (InputCell.self, InputCell.reuseIdentifier)
        case .project:    return (ProjectCategoryCell.self, ProjectCategoryCell.reuseIdentifier)
        }
    }
    
    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .priority, .todo, .input, .project:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        }
    }
    
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .priority:
            return NSCollectionLayoutSize(
                widthDimension: .absolute(40),
                heightDimension: .absolute(40)
            )
        case .project:
            return NSCollectionLayoutSize(
                widthDimension: .absolute(64),
                heightDimension: .absolute(64)
            )
        case .todo, .input:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            )
        }
    }
    
    var groupInsets: NSDirectionalEdgeInsets {
        switch self {
        case .priority, .todo, .input, .project: return .zero
        }
    }
    
    var sectionInsets: NSDirectionalEdgeInsets {
        switch self {
        case .priority, .todo, .input: return .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        case .project: return .zero
        }
    }
}
