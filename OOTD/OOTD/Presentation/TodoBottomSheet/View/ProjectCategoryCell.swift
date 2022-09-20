//
//  ProjectCategoryCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

final class ProjectCategoryCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override func configureAttributes() {
        backgroundColor = .clear
        makeRounded(radius: 32)
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey200.cgColor
        
        titleLabel.do {
            $0.text = "없음"
            $0.textColor = .grey600
            $0.font = .ootdFont(.regular, size: 14)
            $0.textAlignment = .center
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(imageView, titleLabel)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Spacing.s4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Spacing.s4)
        }
    }
}
