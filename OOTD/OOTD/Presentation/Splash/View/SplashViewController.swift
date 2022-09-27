//
//  SplashViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/28.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class SplashViewController: BaseViewController {
    
    private let backgroundImage = UIImageView()
    
    override func configureAttributes() {
        super.configureAttributes()
        
        backgroundImage.do {
            $0.contentMode = .scaleAspectFill
            $0.image = .imgSplash
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
