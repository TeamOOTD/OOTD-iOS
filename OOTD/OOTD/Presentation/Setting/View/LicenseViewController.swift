//
//  LicenseViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/28.
//

import UIKit

import AcknowList
import OOTD_Core

final class LicenseViewController: BaseViewController {
    
    private let rootView = LicenseView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        rootView.navigationBar.leftButton.do {
            $0.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        }
        
        rootView.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    @objc func popViewController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension LicenseViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return License.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: SettingCell.self, for: indexPath)
        cell.configure(License.allCases[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString = License.allCases[indexPath.row].urlString
        openURL(urlString)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
