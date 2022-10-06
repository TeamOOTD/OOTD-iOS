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
    lazy var profileVStackView = UIStackView(arrangedSubviews: [profileView, gitHubRegistrationButton])
    let profileView = ProfileView()
    let gitHubRegistrationButton = UIButton()
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var user: String? {
        return UserDefaults.standard.string(forKey: "gitHubAccount")
    }
    
    override func configureAttributes() {
        backgroundColor = .white

        navigationBar.do {
            $0.title = "설정"
        }
        
        profileVStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }
        
        profileView.do {
            $0.isHidden = false
            $0.isHidden = user == nil
        }
        
        gitHubRegistrationButton.do {
            $0.setImage(.imgGitHubReg, for: .normal)
            $0.isHidden = user != nil
        }
        
        collectionView.do {
            $0.register(SettingItemCell.self)
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
            layout.minimumLineSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            $0.collectionViewLayout = layout
        }
    }
    
    override func configureLayout() {
        addSubviews(navigationBar, profileVStackView, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44.adjustedHeight)
        }
        
        profileVStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s20)
        }
        
        profileView.snp.makeConstraints {
            $0.height.equalTo(120)
        }

        gitHubRegistrationButton.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(profileVStackView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}
