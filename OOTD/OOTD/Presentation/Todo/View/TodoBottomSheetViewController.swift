//
//  TodoBottomSheetViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

struct Todo {
    var priority: Int = 0
    var basicTodo: Int = 0
    var contentName: String = ""
    var studyName: String?
    var project: Int?
}

final class TodoBottomSheetViewController: BaseViewController {

    private lazy var collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var doneButton = ODSButton(.disabled)
    
    var todo: Todo = Todo() {
        didSet {
            collectionView.reloadData()
        }
    }

    private var block: [ODSBasicBlockCell.BasicBlockType] = [.algorithm, .blog, .commit, .study, .direct]
    var section: [TodoBottomSheetSection] = [.priority, .todo, .project] {
        didSet { collectionView.reloadData() }
    }

    override func configureAttributes() {
        view.backgroundColor = .systemBackground
        
        collectionView.do {
            $0.register(
                TodoHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: TodoHeaderView.reuseIdentifier
            )
            
            $0.register(
                ODSBasicBlockCell.self,
                forCellWithReuseIdentifier: ODSBasicBlockCell.reuseIdentifier
            )
            
            $0.register(
                PriorityCell.self,
                forCellWithReuseIdentifier: PriorityCell.reuseIdentifier
            )
            
            $0.register(
                InputCell.self,
                forCellWithReuseIdentifier: InputCell.reuseIdentifier
            )
            
            $0.register(
                ProjectCategoryCell.self,
                forCellWithReuseIdentifier: ProjectCategoryCell.reuseIdentifier
            )

            $0.delegate = self
            $0.dataSource = self
            $0.collectionViewLayout = generateLayout()
        }
        
        doneButton.do {
            $0.title = "확인"
        }

        setupSheet()
    }
    
    override func configureLayout() {
        view.addSubviews(collectionView, doneButton)

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Spacing.s32)
            $0.leading.bottom.trailing.equalToSuperview().inset(Spacing.s24)
        }
        
        doneButton.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview().inset(Spacing.s24)
            $0.height.equalTo(50)
        }
        
    }
    
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = Radii.r20
        }
    }
}

extension TodoBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.section[section] {
        case .priority:  return 6
        case .todo:      return block.count
        case .input:     return 1
        case .project:   return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let priorityCell = collectionView.dequeueReusableCell(withReuseIdentifier: PriorityCell.reuseIdentifier, for: indexPath) as? PriorityCell,
              let todoCell = collectionView.dequeueReusableCell(withReuseIdentifier: ODSBasicBlockCell.reuseIdentifier, for: indexPath) as? ODSBasicBlockCell,
              let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCell.reuseIdentifier, for: indexPath) as? InputCell,
              let projectCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCategoryCell.reuseIdentifier, for: indexPath) as? ProjectCategoryCell
        else {
            return UICollectionViewCell()
        }
        
        switch self.section[indexPath.section] {
        case .priority:
            priorityCell.delegate = self
            priorityCell.index = indexPath.row
            priorityCell.isChoosen = priorityCell.index == todo.priority
            priorityCell.configure(indexPath)
            return priorityCell
        case .todo:
            todoCell.delegate = self
            todoCell.index = indexPath.row
            todoCell.blockType = block[indexPath.row]
            todoCell.isChoosen = todoCell.index == todo.basicTodo
            return todoCell
        case .input:
            inputCell.textField.placeholder = todo.basicTodo == 3 ? "어떤 스터디인가요?" : "투두의 내용을 적어주세요."
            return inputCell
        case .project:
            return projectCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TodoHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TodoHeaderView else {
            return UICollectionReusableView()
        }
        
        switch self.section[indexPath.section] {
        case .priority: headerView.title = "우선 순위"
        case .todo:     headerView.title = "투두 타입"
        case .input:    headerView.title = "컨텐츠"
        case .project:  headerView.title = "관련 프로젝트"
        }
        
        return headerView
    }
}

extension TodoBottomSheetViewController: PriorityCellDelegate {
    
    func priorityCell(_ cell: PriorityCell, index: Int) {
        todo.priority = index
    }
}

extension TodoBottomSheetViewController: ODSBasicBlockCellDelegate {
    
    func basicBlockCell(_ cell: OOTD_UIKit.ODSBasicBlockCell, index: Int) {
        todo.basicTodo = index
        
        if index == 3 || index == 4 {
            section = [.priority, .todo, .input, .project]
        } else {
            section = [.priority, .todo, .project]
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        TabBarController().showPreview(.iPhone13Mini)
    }
}
#endif
