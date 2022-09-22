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
            $0.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.reuseIdentifier)
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
            layout.minimumLineSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            $0.collectionViewLayout = layout
        }
    }
}

extension SettingViewController: UICollectionViewDelegate {
    
}

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

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        SettingViewController().showPreview(.iPhone13Mini)
    }
}
#endif
