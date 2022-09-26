//
//  ProjectArchiveCollectionViewAdapter.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit
import RxSwift
import RxCocoa
import WSTagsField

protocol ProjectArchiveCollectionViewAdapterDataSource: AnyObject {
    var numberOfSections: Int { get }
    var numberOfItems: Int { get }
    var project: PublishRelay<Project> { get }
    var name: BehaviorRelay<String> { get }
    var desc: BehaviorRelay<String> { get }
    var link: BehaviorRelay<String> { get }
    var member: BehaviorRelay<[String]> { get }
    var startDate: BehaviorRelay<Date?> { get }
    var endDate: BehaviorRelay<Date?> { get }
    var tech: BehaviorRelay<[String]> { get }
    var memo: BehaviorRelay<String?> { get}

    func numberOfItems(section: Int) -> Int
    func fetchSection(section: Int) -> ProjectArchiveSection
}

protocol ProjectArchiveCollectionViewAdapterDelegate: AnyObject {
    func reload()
    func startDateButtonTapped(date: Date?)
    func endDateButtonTapped(date: Date?)
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
            PeriodCell.self,
            forCellWithReuseIdentifier: PeriodCell.reuseIdentifier
        )
        
        collectionView.register(
            TagFieldCell.self,
            forCellWithReuseIdentifier: TagFieldCell.reuseIdentifier
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
        let section = adapterDataSource?.fetchSection(section: indexPath.section)
        
        switch section {
        case .logo:
            guard let logoCell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCell.reuseIdentifier, for: indexPath) as? LogoCell else {
                return UICollectionViewCell()
            }
            return logoCell
            
        case .name:
            guard let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCell.reuseIdentifier, for: indexPath) as? InputCell else {
                return UICollectionViewCell()
            }
            
            inputCell.textField.placeholder = section?.placeholder
            
            inputCell.textField.rx.text.orEmpty
                .bind(to: adapterDataSource!.name)
                .disposed(by: inputCell.disposedBag)

            return inputCell
            
        case .desc:
            guard let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCell.reuseIdentifier, for: indexPath) as? InputCell else {
                return UICollectionViewCell()
            }
            
            inputCell.textField.placeholder = section?.placeholder
            
            inputCell.textField.rx.text.orEmpty
                .bind(to: adapterDataSource!.desc)
                .disposed(by: inputCell.disposedBag)
            
            return inputCell
            
        case .gitHubLink:
            guard let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCell.reuseIdentifier, for: indexPath) as? InputCell else {
                return UICollectionViewCell()
            }
            
            inputCell.textField.placeholder = section?.placeholder
            
            inputCell.textField.rx.text.orEmpty
                .bind(to: adapterDataSource!.link)
                .disposed(by: inputCell.disposedBag)
            
            return inputCell
            
        case .period:
            guard let periodCell = collectionView.dequeueReusableCell(withReuseIdentifier: PeriodCell.reuseIdentifier, for: indexPath) as? PeriodCell else {
                return UICollectionViewCell()
            }
            periodCell.delegate = self
            periodCell.bind(adapterDataSource!)
            return periodCell
            
        case .member, .tech:
            guard let tagFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagFieldCell.reuseIdentifier, for: indexPath) as? TagFieldCell else {
                return UICollectionViewCell()
            }
            tagFieldCell.configure(section: section)
            tagFieldCell.bind(adapterDataSource!, section: section)
            tagFieldCell.tagField.onDidChangeHeightTo = { [weak self] _, _ in
                self?.delegate?.reload()
            }
            return tagFieldCell
            
        case .memo:
            guard let memoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoCell.reuseIdentifier, for: indexPath) as? MemoCell else {
                return UICollectionViewCell()
            }
            memoCell.textViewPlaceHolder = section?.placeholder
            memoCell.delegate = self
            memoCell.textView.rx.text.orEmpty
                .bind(to: adapterDataSource!.memo)
                .disposed(by: memoCell.disposedBag)
            return memoCell
            
        default:
            guard let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCell.reuseIdentifier, for: indexPath) as? InputCell else {
                return UICollectionViewCell()
            }
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
        headerView.isNecessary = adapterDataSource?.fetchSection(section: indexPath.section).isNecessary ?? false
        
        return headerView
    }
}

extension ProjectArchiveCollectionViewAdapter: UICollectionViewDelegate {}

extension ProjectArchiveCollectionViewAdapter: PeriodCellDelegate {
    func startDateButtonTapped(_ cell: PeriodCell, date: Date?) {
        delegate?.startDateButtonTapped(date: date)
    }
    
    func endDateButtonTapped(_ cell: PeriodCell, date: Date?) {
        delegate?.endDateButtonTapped(date: date)
    }
}

extension ProjectArchiveCollectionViewAdapter: MemoCellDelegate {
    func textViewHeightDidChange(_ cell: MemoCell) {
        delegate?.reload()
    }
}

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
        case .logo, .member, .tech, .memo:
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
