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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureAttributes() {
        super.configureAttributes()
    }
}

extension ProjectViewController {

}
