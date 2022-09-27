//
//  ProjectArchiveView.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectArchiveView: BaseView {

    let navigationBar = ODSNavigationBar()
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configureAttributes() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.leftBarItem = .back
            $0.title = "아카이빙"
            $0.rightButton.setTitle("저장", for: .normal)
            $0.rightButton.setTitleColor(.grey900, for: .normal)
            $0.rightButton.isEnabled = false
        }
        
        collectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    override func configureLayout() {
        addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44.adjustedHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s16)
            $0.bottom.equalToSuperview()
        }
    }
}
