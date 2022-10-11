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
    
    // MARK: - UI Components
    
    private let rootView = SettingView()
    
    // MARK: - Properties
    
    private let dataSource: RxCollectionViewSectionedReloadDataSource<SettingViewSection>
    
    // MARK: - Initializer
    
    init(reactor: SettingViewReactor) {
        defer { self.reactor = reactor }
        self.dataSource = SettingViewController.dataSourceFactory()
        super.init()
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }

    override func configureAttributes() {
        super.configureAttributes()
        
        rootView.gitHubRegistrationButton.do {
            $0.addTarget(self, action: #selector(pushToGitHubViewController), for: .touchUpInside)
        }
    }
    
    // MARK: - Binding
    
    func bind(reactor: SettingViewReactor) {
        // State
        reactor.state.map { $0.sections }
            .bind(to: rootView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { ($0.commit, $0.todo) }
            .subscribe { [weak self] in
                self?.rootView.profileView.commit = $0
                self?.rootView.profileView.todoCount = $1
            }
            .disposed(by: disposeBag)

        // View
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.fetch }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .subscribe { [weak self] _ in
                self?.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: self.disposeBag)
        
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
}

extension SettingViewController {
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
    
    @objc func pushToGitHubViewController() {
        let viewController = GitHubRegistrationViewController()
        viewController.isNavigationBarHidden = false
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Bool> {
        return methodInvoked(#selector(Base.viewDidLoad))
            .map { $0.first as? Bool ?? false }
    }
    
    var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
}
