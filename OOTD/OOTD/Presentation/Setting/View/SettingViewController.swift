//
//  SettingViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import OOTD_Core

final class SettingViewController: BaseViewController {
    
    private let rootView = SettingView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        rootView.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
        }
    }
}

extension SettingViewController: UICollectionViewDelegate {}

extension SettingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SettingOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingOption.allCases[section].numberOfRowInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else { return UICollectionViewCell() }
        cell.configure(SettingOption.allCases[indexPath.section].contents[indexPath.row])
        
        if SettingOption.allCases[indexPath.section].contents.indices.last == indexPath.row {
            cell.lineView.isHidden = true
        }
        return cell
    }
}
