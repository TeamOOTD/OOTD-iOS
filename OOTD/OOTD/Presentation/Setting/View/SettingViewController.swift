//
//  SettingViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import AcknowList
import OOTD_Core

final class SettingViewController: BaseViewController {
    
    private let repository = StorageRepository<Todo>()
    private let rootView = SettingView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTodo()
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        rootView.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func fetchTodo() {
        var date = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var dateComponents = DateComponents()
        dateComponents.year = date.year
        dateComponents.month = date.month
        dateComponents.day = date.day
        guard let today = Calendar.current.date(from: dateComponents) else { return }
        let todo = repository.fetchByDate(by: today, keyPath: "date")
        rootView.profileView.todoCount = todo.count
    }
}

extension SettingViewController: UICollectionViewDelegate {}

extension SettingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SettingSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingSection.allCases[section].numberOfRowInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: SettingCell.self, for: indexPath)
        let row = SettingSection.allCases[indexPath.section].contents[indexPath.row]
        
        switch row {
        case .appVersion:
            cell.configure(row.rawValue, desc: fetchAppVersion())
        default:
            cell.configure(row.rawValue)
        }

        if SettingSection.allCases[indexPath.section].contents.indices.last == indexPath.row {
            cell.lineView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = SettingSection.allCases[indexPath.section].contents[indexPath.row]
        
        switch row {
        case .backupAndRestore:
            presentAlert(title: "준비중이에요.")
        case .license:
            pushToLicenseViewController()
        default:
            return
        }
    }
    
    private func fetchAppVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        
        return version
    }
    
    private func pushToLicenseViewController() {
        let viewController = LicenseViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
