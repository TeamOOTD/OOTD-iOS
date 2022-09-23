//
//  ProjectListEmptyView.swift
//  OOTD
//
//  Created by taekki on 2022/09/23.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectListEmptyView: BaseView {
    
    lazy var emptyImageView = UIImageView()
    
    override func configureAttributes() {
        emptyImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .imgProjectEmpty
        }
    }
    
    override func configureLayout() {
        addSubview(emptyImageView)
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(110.adjustedHeight)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(256)
        }
    }
}
