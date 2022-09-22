//
//  ProjectViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import OOTD_Core

final class ProjectViewController: BaseViewController {
    
    private let rootView = ProjectView()
    
    override func loadView() {
        self.view = rootView
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
