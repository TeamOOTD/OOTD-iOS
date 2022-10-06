//
//  SettingViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import OOTD_Core
import ReactorKit
import RxCocoa
import RxDataSources

final class SettingViewController: BaseViewController, View {
    
    private let repository = StorageRepository<Todo>()
    private let rootView = SettingView()
    
    private let dataSource: RxCollectionViewSectionedReloadDataSource<SettingViewSection>
    
    init(reactor: SettingViewReactor) {
        defer { self.reactor = reactor }
        self.dataSource = SettingViewController.dataSourceFactory()
        super.init()
    }
    
    private static func dataSourceFactory() -> RxCollectionViewSectionedReloadDataSource<SettingViewSection> {
        return .init { _, collectionView, indexPath, sectionItem in
            let cell = collectionView.dequeueReusableCell(cellType: SettingItemCell.self, for: indexPath)
            switch sectionItem {
            case let .token(reactor):
                cell.reactor = reactor
                
            case let .backupAndRestore(reactor):
                cell.reactor = reactor
                
            case let .license(reactor):
                cell.reactor = reactor
                
            case let .appVersion(reactor):
                cell.reactor = reactor
            }
            return cell
        }
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        fetchTodo()
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        rootView.gitHubRegistrationButton.do {
            $0.addTarget(self, action: #selector(pushToGitHubViewController), for: .touchUpInside)
        }
    }
    
    func bind(reactor: SettingViewReactor) {
        // State
        reactor.state.map { $0.sections }
            .bind(to: rootView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // View
        rootView.collectionView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                guard let sectionItem = self?.dataSource[indexPath] else { return }
                switch sectionItem {
                case .token:
                    let viewController = TokenViewController()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    
                case .backupAndRestore:
                    self?.presentAlert(title: "준비중이에요.")
                    
                case .license:
                    let viewController = LicenseViewController()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    
                default:
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchTodo() {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var dateComponents = DateComponents()
        dateComponents.year = date.year
        dateComponents.month = date.month
        dateComponents.day = date.day
        guard let today = Calendar.current.date(from: dateComponents) else { return }
        let todo = repository.fetchByDate(by: today, keyPath: "date")
        rootView.profileView.commit = UserDefaults.standard.integer(forKey: "todayCommit")
        rootView.profileView.todoCount = todo.count
    }
    
    @objc func pushToGitHubViewController() {
        let viewController = GitHubRegistrationViewController()
        viewController.isNavigationBarHidden = false
        navigationController?.pushViewController(viewController, animated: true)
    }
}
