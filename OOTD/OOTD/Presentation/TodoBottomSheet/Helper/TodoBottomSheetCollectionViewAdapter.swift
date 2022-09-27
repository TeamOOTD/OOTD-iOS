//
//  TodoBottomSheetCollectionViewAdapter.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import UIKit

import OOTD_Core
import OOTD_UIKit
import RxSwift

protocol TodoBottomSheetCollectionViewAdapterDataSource: AnyObject {
    var todo: Todo { get }
    var block: [ODSBasicBlockCell.BasicBlockType] { get }
    var numberOfSections: Int { get }
    var projects: [(String, UIImage?)] { get }
    
    func fetchSection(section: Int) -> TodoBottomSheetSection
    func numberOfItems(section: Int) -> Int
}

protocol TodoBottomSheetCollectionViewAdapterDelegate: AnyObject {
    func priorityCellTapped(at index: Int)
    func todoBlockCellTapped(at index: Int)
    func inputTextFieldValueChanged(text: String?)
    func projectCategoryCellTapped(at index: Int)
}

final class TodoBottomSheetCollectionViewAdapter: NSObject {

    weak var adapterDataSource: TodoBottomSheetCollectionViewAdapterDataSource?
    weak var delegate: TodoBottomSheetCollectionViewAdapterDelegate?
    
    init(
        collectionView: UICollectionView,
        adapterDataSource: TodoBottomSheetCollectionViewAdapterDataSource?,
        delegate: TodoBottomSheetCollectionViewAdapterDelegate?
    ) {
        super.init()

        self.adapterDataSource = adapterDataSource
        self.delegate = delegate
        
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            SectionHeaderView.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.register(ODSBasicBlockCell.self)
        collectionView.register(PriorityCell.self)
        collectionView.register(InputCell.self)
        collectionView.register(ProjectCategoryCell.self)
    }
}

extension TodoBottomSheetCollectionViewAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return adapterDataSource?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adapterDataSource?.numberOfItems(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let section = adapterDataSource?.fetchSection(section: indexPath.section)
        let todo = adapterDataSource?.todo
        
        switch section {
        case .priority:
            let cell = collectionView.dequeueReusableCell(cellType: PriorityCell.self, for: indexPath)
            cell.delegate = self
            cell.index = indexPath.row
            cell.isChoosen = cell.index == todo?.priority
            cell.configure(indexPath)
            return cell
            
        case .todo:
            let cell = collectionView.dequeueReusableCell(cellType: ODSBasicBlockCell.self, for: indexPath)
            cell.delegate = self
            cell.index = indexPath.row
            cell.blockType = adapterDataSource?.block[indexPath.row]
            cell.isChoosen = cell.index == todo?.todoType
            return cell
            
        case .input:
            let cell = collectionView.dequeueReusableCell(cellType: InputCell.self, for: indexPath)
            cell.handler = { [weak self] text in
                self?.delegate?.inputTextFieldValueChanged(text: text)
            }
            cell.textField.placeholder = todo?.todoType == 4 ? "투두의 내용을 적어주세요." : "어떤 스터디인가요?"
            cell.textField.text = todo?.contents
            return cell
            
        case .project:
            let cell = collectionView.dequeueReusableCell(cellType: ProjectCategoryCell.self, for: indexPath)
            let projects = adapterDataSource!.projects
            cell.index = indexPath.row
            cell.delegate = self
            if projects.isNotEmpty && indexPath.row <= projects.indices.last! {
                cell.configure(at: indexPath, with: todo, project: projects[indexPath.row])
            }
            cell.isChoosen = cell.projectID == todo?.projectID
            return cell
            
        default:
            return UICollectionViewCell()
        }   
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        let section = adapterDataSource?.fetchSection(section: indexPath.section)
        
        switch section {
        case .priority: headerView.title = "우선 순위"
        case .todo:     headerView.title = "투두 타입"
        case .input:    headerView.title = "컨텐츠"
        case .project:  headerView.title = "관련 프로젝트"
        default: break
        }
        
        return headerView
    }
}

extension TodoBottomSheetCollectionViewAdapter: UICollectionViewDelegate {}

extension TodoBottomSheetCollectionViewAdapter: PriorityCellDelegate {
    
    func priorityCell(_ cell: PriorityCell, index: Int) {
        delegate?.priorityCellTapped(at: index)
    }
}

extension TodoBottomSheetCollectionViewAdapter: ODSBasicBlockCellDelegate {
    
    func basicBlockCell(_ cell: OOTD_UIKit.ODSBasicBlockCell, index: Int) {
        delegate?.todoBlockCellTapped(at: index)
    }
}

extension TodoBottomSheetCollectionViewAdapter: ProjectCategoryCellDelegate {
    
    func projectCategoryCell(_ cell: ProjectCategoryCell, index: Int) {
        delegate?.projectCategoryCellTapped(at: index)
    }
}

// MARK: - Layout

extension TodoBottomSheetCollectionViewAdapter {

    func generateLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNum, _)
            -> NSCollectionLayoutSection? in

            return self?.generateSection(sectionType: self?.adapterDataSource?.fetchSection(section: sectionNum) ?? .todo)
        }
    }

    private func generateItem(sectionType: TodoBottomSheetSection) -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: sectionType.itemSize)
    }

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
