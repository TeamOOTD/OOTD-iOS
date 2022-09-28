//
//  LicenseView.swift
//  OOTD
//
//  Created by taekki on 2022/09/28.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class LicenseView: BaseView {

    let navigationBar = ODSNavigationBar()
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configureAttributes() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.leftBarItem = .back
            $0.title = "오픈 라이선스"
        }

        collectionView.do {
            $0.register(SettingCell.self)
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
            layout.minimumLineSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            $0.collectionViewLayout = layout
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
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}
