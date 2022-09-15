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

final class TodoBottomSheetViewController: BaseViewController {
    
    enum Mode {
        case basic
        case direct
    }
    
    private let segmentedControl = ODSSegmentedControl(buttonTitles: ["기본 제공", "직접 입력"])
    private let doneButton = UIButton()
    private lazy var collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var block: [ODSBasicBlockCell.BasicBlockType] = [.algorithm, .blog, .commit, .study]

    override func configureAttributes() {
        view.backgroundColor = .systemBackground
        
        segmentedControl.do {
            $0.backgroundColor = .grey200
        }
        
        doneButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.grey500, for: .normal)
            $0.titleLabel?.font = .ootdFont(.bold, size: 14)
        }
        
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

            $0.delegate = self
            $0.dataSource = self
            $0.collectionViewLayout = generateLayout()
        }
        
        setupSheet()
    }
    
    override func configureLayout() {
        view.addSubviews(segmentedControl, doneButton, collectionView)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Spacing.s32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(194)
            $0.height.equalTo(28)
        }
        
        doneButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Spacing.s20)
            $0.centerY.equalTo(segmentedControl)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(Spacing.s24)
            $0.leading.bottom.trailing.equalToSuperview().inset(Spacing.s24)
        }
    }
    
    private func setupSheet() {
        isModalInPresentation = true

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return block.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ODSBasicBlockCell.reuseIdentifier, for: indexPath) as? ODSBasicBlockCell else {
            return UICollectionViewCell()
        }
        cell.blockType = block[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TodoHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TodoHeaderView else {
            return UICollectionReusableView()
        }
        headerView.title = "기본 투두"
        return headerView
    }
}

extension TodoBottomSheetViewController {
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
        section.interGroupSpacing = 12
        
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

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        TabBarController().showPreview(.iPhone13Mini)
    }
}
#endif
