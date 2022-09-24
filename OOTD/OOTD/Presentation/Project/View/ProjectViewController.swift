//
//  ProjectViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import RxCocoa
import RxSwift
import OOTD_Core
import OOTD_UIKit

final class ProjectViewController: BaseViewController {
    
    private let viewModel: ProjectListViewModel!
    private let disposeBag = DisposeBag()
    
    private let rootView = ProjectView()
    private let emptyView = ProjectListEmptyView()

    init(viewModel: ProjectListViewModel!) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindCollectionView()
        viewModel.viewDidLoad.accept(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureAttributes() {
        super.configureAttributes()

        rootView.navigationBar.rightButton.addTarget(self, action: #selector(pushToProjectArchiveViewController), for: .touchUpInside)
    }
}

extension ProjectViewController {
    
    @objc private func pushToProjectArchiveViewController() {
        let viewController = ProjectArchiveViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProjectViewController {
    
    private func bindCollectionView() {
        viewModel.projects
            .filter { [weak self] in
                self?.rootView.collectionView.backgroundView = $0.isEmpty ? self?.emptyView : nil
                return $0.isNotEmpty
            }
            .bind(to: rootView.collectionView.rx.items(
                cellIdentifier: ProjectListCell.reuseIdentifier,
                cellType: ProjectListCell.self)) { _, _, _ in }
            .disposed(by: disposeBag)
    }
}
