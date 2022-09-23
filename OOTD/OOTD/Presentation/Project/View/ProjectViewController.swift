//
//  ProjectViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectViewController: BaseViewController {
    
    private let rootView = ProjectView()
    private let emptyView = ProjectListEmptyView()
    
    private let dataSource: [String] = []
    
    override func loadView() {
        self.view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureCollectionView()
        rootView.navigationBar.rightButton.addTarget(self, action: #selector(pushToProjectArchiveViewController), for: .touchUpInside)
    }
}

extension ProjectViewController {
    
    @objc private func pushToProjectArchiveViewController() {
        let viewController = ProjectArchiveViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.register(ProjectListCell.self, forCellWithReuseIdentifier: ProjectListCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 82.adjustedHeight)
        layout.minimumLineSpacing = Spacing.s8
        rootView.collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rootView.collectionView.backgroundView = dataSource.isEmpty ? emptyView : nil
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectListCell.reuseIdentifier, for: indexPath) as? ProjectListCell else {
            return UICollectionViewCell()
        }
        cell.createTagView(with: ["Swift", "UIKit", "Realm"])
        return cell
    }
}
