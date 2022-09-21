//
//  TodoListCollectionViewAdapter.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import UIKit
import OOTD_Core

protocol TodoListCollectionViewAdapterDataSource: AnyObject {
    var numberOfSections: Int { get }
    var numberOfItems: Int { get }
    
    func todo(at index: Int) -> Todo
}

protocol TodoListCollectionViewAdapterDelegate: AnyObject {
    func todoHeaderViewCreateButtonDidTap()
    func todoTapped(_ todo: Todo, at index: Int)
}

final class TodoListCollectionViewAdapter: NSObject {

    weak var adapterDataSource: TodoListCollectionViewAdapterDataSource?
    weak var delegate: TodoListCollectionViewAdapterDelegate?
    
    init(
        collectionView: UICollectionView,
        adapterDataSource: TodoListCollectionViewAdapterDataSource?,
        delegate: TodoListCollectionViewAdapterDelegate?
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
            TodoCell.self,
            forCellWithReuseIdentifier: TodoCell.reuseIdentifier
        )
    }
}

extension TodoListCollectionViewAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return adapterDataSource?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adapterDataSource?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell,
              let todo = adapterDataSource?.todo(at: indexPath.row) else { return UICollectionViewCell() }
        cell.configure(with: todo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TodoSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TodoSectionHeaderView else {
            return UICollectionReusableView()
        }
        headerView.title = "🌱 오늘의 할 일"
        headerView.rightIcon = .icnPlusCircle
        headerView.delegate = self
        return headerView
    }
}

extension TodoListCollectionViewAdapter: TodoSectionHeaderViewDelegate {
    
    func todoSectionHeaderViewCreateButtonTapped(_ todoHeaderView: TodoSectionHeaderView) {
        delegate?.todoHeaderViewCreateButtonDidTap()
    }
}

extension TodoListCollectionViewAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let todo = adapterDataSource?.todo(at: indexPath.row) else { return }
        delegate?.todoTapped(todo, at: indexPath.row)
    }
}

extension TodoListCollectionViewAdapter {

    private func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [generateHeader()]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
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
