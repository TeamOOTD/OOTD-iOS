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
    var project: Project { get set }
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
            ofKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.register(LogoCell.self)
        collectionView.register(InputCell.self)
        collectionView.register(PeriodCell.self)
        collectionView.register(TagFieldCell.self)
        collectionView.register(MemoCell.self)
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
            let cell = collectionView.dequeueReusableCell(cellType: LogoCell.self, for: indexPath)
            return cell
            
        case .name:
            let cell = collectionView.dequeueReusableCell(cellType: InputCell.self, for: indexPath)
            cell.textField.placeholder = section?.placeholder
            cell.textField.text = adapterDataSource?.name.value
            cell.textField.rx.text.orEmpty
                .bind(to: adapterDataSource!.name)
                .disposed(by: cell.disposedBag)
            return cell
            
        case .desc:
            let cell = collectionView.dequeueReusableCell(cellType: InputCell.self, for: indexPath)
            cell.textField.placeholder = section?.placeholder
            cell.textField.text = adapterDataSource?.desc.value
            cell.textField.rx.text.orEmpty
                .bind(to: adapterDataSource!.desc)
                .disposed(by: cell.disposedBag)
            return cell
            
        case .gitHubLink:
            let cell = collectionView.dequeueReusableCell(cellType: InputCell.self, for: indexPath)
            cell.textField.placeholder = section?.placeholder
            cell.textField.text = adapterDataSource?.link.value
            cell.textField.rx.text.orEmpty
                .bind(to: adapterDataSource!.link)
                .disposed(by: cell.disposedBag)
            return cell
            
        case .period:
            let cell = collectionView.dequeueReusableCell(cellType: PeriodCell.self, for: indexPath)
            cell.delegate = self
            cell.bind(adapterDataSource!)
            return cell
            
        case .member, .tech:
            let cell = collectionView.dequeueReusableCell(cellType: TagFieldCell.self, for: indexPath)
            cell.configure(section: section)
            cell.bind(adapterDataSource!, section: section)
            cell.tagField.onDidChangeHeightTo = { [weak self] _, _ in
                self?.delegate?.reload()
            }
            return cell
            
        case .memo:
            let cell = collectionView.dequeueReusableCell(cellType: MemoCell.self, for: indexPath)
            cell.textViewPlaceHolder = section?.placeholder
            cell.textView.text = adapterDataSource?.memo.value
            cell.delegate = self
            cell.textView.rx.text.orEmpty
                .bind(to: adapterDataSource!.memo)
                .disposed(by: cell.disposedBag)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            TodoSectionHeaderView.self,
            ofKind: kind,
            for: indexPath
        )
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
