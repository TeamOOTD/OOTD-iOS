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
        viewModel.shouldUpdateProjects()
    }
    
    override func configureAttributes() {
        super.configureAttributes()

        rootView.navigationBar.rightButton.addTarget(self, action: #selector(pushToProjectArchiveViewController), for: .touchUpInside)
    }
}

extension ProjectViewController {
    
    @objc private func pushToProjectArchiveViewController() {
        let viewModel = ProjectArchiveViewModel(projectRepository: StorageRepository<Project>())
        let viewController = ProjectArchiveViewController(viewModel: viewModel)
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
                cellType: ProjectListCell.self)) { _, elem, cell in
                    cell.createTagView(with: elem.tech)
                    cell.configure(with: elem)
                }
            .disposed(by: disposeBag)

        rootView.collectionView.rx.modelSelected(Project.self)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] model in
                self?.pushProjectArchiveViewController(of: model)

            }
            .disposed(by: disposeBag)
    }
    
    private func pushProjectArchiveViewController(of model: Project) {
        let viewModel = ProjectArchiveViewModel(projectRepository: StorageRepository<Project>())
        
        viewModel.project = model
        viewModel.isEditMode.accept(true)
        viewModel.name.accept(model.name)
        viewModel.desc.accept(model.desc)
        viewModel.link.accept(model.gitHubLink)
        viewModel.member.accept(model.member)
        viewModel.startDate.accept(model.startDate)
        viewModel.endDate.accept(model.endDate)
        viewModel.tech.accept(model.tech)
        viewModel.memo.accept(model.memo)
        
        let viewController = ProjectArchiveViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
