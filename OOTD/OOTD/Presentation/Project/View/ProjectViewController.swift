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
    
    private let rootView = ProjectView()
    private let emptyView = ProjectListEmptyView()

    init(viewModel: ProjectListViewModel) {
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
        viewModel.projects.bind { [weak self] projects in
            self?.rootView.collectionView.backgroundView = projects.isEmpty ? self?.emptyView : nil
        }
        .disposed(by: disposeBag)
        
        viewModel.projects.bind(to: rootView.collectionView.rx.items(
                cellIdentifier: ProjectListCell.reuseIdentifier,
                cellType: ProjectListCell.self)) { [weak self] _, elem, cell in
                    let image = self?.viewModel.fetchImage(filename: elem.id)
                    cell.createTagView(with: elem.tech)
                    cell.configure(with: elem, image: image)
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
        let image = self.viewModel.fetchImage(filename: model.id)
        
        viewModel.project = model
        viewModel.isEditMode.accept(true)
        viewModel.logo.accept(image)
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
