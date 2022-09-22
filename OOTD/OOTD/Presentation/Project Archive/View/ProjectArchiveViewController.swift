//
//  ProjectArchiveViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectArchiveViewController: BaseViewController, ProjectArchiveCollectionViewAdapterDelegate {
    
    private let viewModel = ProjectArchiveViewModel()
    private lazy var adapter: ProjectArchiveCollectionViewAdapter = {
        let adapter = ProjectArchiveCollectionViewAdapter(collectionView: rootView.collectionView, adapterDataSource: viewModel, delegate: self)
        return adapter
    }()
    
    private let rootView = ProjectArchiveView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureAttributes() {
        rootView.navigationBar.leftButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    }
    
    override func bind() {
        adapter.adapterDataSource = viewModel
    }
}

extension ProjectArchiveViewController {
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
