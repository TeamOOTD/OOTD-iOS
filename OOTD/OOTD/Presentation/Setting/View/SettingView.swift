//
//  SettingView.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class SettingView: BaseView {

    let navigationBar = ODSNavigationBar()
    let gitHubRegistrationButton = UIButton()
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configureAttributes() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.title = "설정"
        }
        
        gitHubRegistrationButton.do {
            $0.setImage(.imgGitHubReg, for: .normal)
        }
    }
    
    override func configureLayout() {
        addSubviews(navigationBar, gitHubRegistrationButton, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44.adjustedHeight)
        }
        
        gitHubRegistrationButton.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s20)
            $0.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(gitHubRegistrationButton.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}
