//
//  ProjectArchiveCollectionViewAdapter.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

protocol ProjectArchiveCollectionViewAdapterDataSource: AnyObject {
    var numberOfSections: Int { get }
    var numberOfItems: Int { get }

    func numberOfItems(section: Int) -> Int
    func fetchSection(section: Int) -> ProjectArchiveSection
}

protocol ProjectArchiveCollectionViewAdapterDelegate: AnyObject {
}

final class ProjectArchiveCollectionViewAdapter: NSObject {

    weak var adapterDataSource: ProjectArchiveCollectionViewAdapterDataSource?
    weak var delegate: ProjectArchiveCollectionViewAdapterDelegate?
    
    init(
        collectionView: UICollectionView,
        adapterDataSource: ProjectArchiveCollectionViewAdapterDataSource?,
        delegate: ProjectArchiveCollectionViewAdapterDelegate?
    ) {
        super.init()

        self.adapterDataSource = adapterDataSource
        self.delegate = delegate
        
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            TodoSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TodoSectionHeaderView.reuseIdentifier
        )
        
        collectionView.register(
            LogoCell.self,
            forCellWithReuseIdentifier: LogoCell.reuseIdentifier
        )

        collectionView.register(
            InputCell.self,
            forCellWithReuseIdentifier: InputCell.reuseIdentifier
        )
        
        collectionView.register(
            MemoCell.self,
            forCellWithReuseIdentifier: MemoCell.reuseIdentifier
        )
    }
}

extension ProjectArchiveCollectionViewAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return adapterDataSource?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adapterDataSource?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let logoCell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCell.reuseIdentifier, for: indexPath) as? LogoCell,
              let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCell.reuseIdentifier, for: indexPath) as? InputCell,
              let memoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoCell.reuseIdentifier, for: indexPath) as? MemoCell
        else { return UICollectionViewCell() }
        
        let section = adapterDataSource?.fetchSection(section: indexPath.section)
        
        switch section {
        case .logo:
            return logoCell
        case .memo:
            memoCell.textView.text = section?.placeholder
            return memoCell
        default:
            inputCell.textField.placeholder = section?.placeholder
            inputCell.textField.font = .systemFont(ofSize: 14)
            return inputCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TodoSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TodoSectionHeaderView else { return UICollectionReusableView() }
        
        headerView.title = adapterDataSource?.fetchSection(section: indexPath.section).rawValue
        
        return headerView
    }
}

extension ProjectArchiveCollectionViewAdapter: UICollectionViewDelegate {}

// MARK: - Layout

extension ProjectArchiveCollectionViewAdapter {

    func generateLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNum, _)
            -> NSCollectionLayoutSection? in

            return self?.generateSection(sectionType: self?.adapterDataSource?.fetchSection(section: sectionNum) ?? .memo)
        }
    }

    private func generateItem(sectionType: ProjectArchiveSection) -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: sectionType.itemSize)
    }

    private func generateGroup(item: NSCollectionLayoutItem, sectionType: ProjectArchiveSection)
    -> NSCollectionLayoutGroup {
        
        switch sectionType {
        case .logo:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: sectionType.groupSize,
                subitems: [item]
            )
        default:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: sectionType.groupSize,
                subitems: [item]
            )
        }
    }

    typealias ScollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
    private func generateSection(sectionType: ProjectArchiveSection)
    -> NSCollectionLayoutSection {
        
        let item = generateItem(sectionType: sectionType)
        
        let group = generateGroup(item: item, sectionType: sectionType)
        group.contentInsets = sectionType.groupInsets
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionType.sectionInsets
        section.boundarySupplementaryItems = [generateHeader()]
        section.interGroupSpacing = 20
        return section
    }

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
