//
//  TodoBottomSheetViewController+Layout.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import OOTD_Core
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

extension TodoBottomSheetViewController {
    // 레이아웃 생성
    func generateLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNum, _)
            -> NSCollectionLayoutSection? in

            return self?.generateSection(sectionType: self?.section[sectionNum] ?? .todo)
        }
    }
    
    // 아이템 생성
    private func generateItem(sectionType: TodoBottomSheetSection) -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: sectionType.itemSize)
    }
    
    // 그룹 생성
    private func generateGroup(item: NSCollectionLayoutItem, sectionType: TodoBottomSheetSection)
    -> NSCollectionLayoutGroup {
        
        switch sectionType {
        case .project, .priority:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: sectionType.groupSize,
                subitems: [item]
            )
        case .todo, .input:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: sectionType.groupSize,
                subitems: [item]
            )
        }
    }
    
    // 섹션 생성
    typealias ScollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
    private func generateSection(sectionType: TodoBottomSheetSection)
    -> NSCollectionLayoutSection {
        
        let item = generateItem(sectionType: sectionType)
        
        let group = generateGroup(item: item, sectionType: sectionType)
        group.contentInsets = sectionType.groupInsets
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionType.sectionInsets
        section.boundarySupplementaryItems = [generateHeader()]
        section.interGroupSpacing = 10
        
        if sectionType == .priority || sectionType == .project {
            section.orthogonalScrollingBehavior = .continuous
        }
        
        return section
    }
    
    // 헤더 생성
    private func generateHeader()
    -> NSCollectionLayoutBoundarySupplementaryItem {

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return headerElement
    }
}
