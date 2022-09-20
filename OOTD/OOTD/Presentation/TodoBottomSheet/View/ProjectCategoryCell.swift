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

protocol ProjectCategoryCellDelegate: AnyObject {
    func projectCategoryCell(_ cell: ProjectCategoryCell, index: Int)
}

final class ProjectCategoryCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    var index: Int?
    var isChoosen: Bool = false {
        didSet {
            layer.borderColor = isChoosen ? UIColor.yellow800.cgColor : UIColor.grey200.cgColor
        }
    }
    
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

extension ProjectCategoryCell {
    
    func configure(at indexPath: IndexPath, with todo: Todo?) {
        self.index = indexPath.row
        isChoosen = indexPath.row == todo?.projectID
    }
}
