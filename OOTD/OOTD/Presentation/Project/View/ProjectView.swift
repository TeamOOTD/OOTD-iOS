//
//  ProjectView.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectView: BaseView {
    
    let navigationBar = ODSNavigationBar()
    private let titleLabel = UILabel()
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func configureAttributes() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.rightBarItem = .add
        }
        
        titleLabel.do {
            $0.text = "프로젝트"
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 24)
        }
        
        collectionView.do {
            $0.collectionViewLayout = collectionViewLayout()
            
            $0.register(
                ProjectListCell.self,
                forCellWithReuseIdentifier: ProjectListCell.reuseIdentifier
            )
        }
    }
    
    override func configureLayout() {
        addSubviews(navigationBar, titleLabel, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44.adjustedHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(Spacing.s8)
            $0.leading.equalToSuperview().offset(Spacing.s16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Spacing.s16)
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension ProjectView {
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 82.adjustedHeight)
        layout.minimumLineSpacing = Spacing.s8
        return layout
    }
}
