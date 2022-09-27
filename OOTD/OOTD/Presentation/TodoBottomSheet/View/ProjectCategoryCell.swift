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
    
    lazy var projectButton = UIButton()
    let titleLabel = UILabel()
    
    weak var delegate: ProjectCategoryCellDelegate?
    var projectID: String = ""
    var index: Int?
    var isChoosen: Bool = false {
        didSet {
            layer.borderColor = isChoosen ? UIColor.yellow800.cgColor : UIColor.grey200.cgColor
        }
    }
    
    override func configureAttributes() {
        backgroundColor = .clear
        makeRounded(radius: 32)
        layer.borderWidth = 3
        layer.borderColor = UIColor.grey200.cgColor
        
        projectButton.do {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

        titleLabel.do {
            $0.text = "없음"
            $0.textColor = .grey600
            $0.font = .ootdFont(.regular, size: 14)
            $0.textAlignment = .center
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(titleLabel, projectButton)
        projectButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Spacing.s4)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        projectButton.setImage(nil, for: .normal)
        projectID = ""
    }
}

extension ProjectCategoryCell {
    
    func configure(at indexPath: IndexPath, with todo: Todo?, project: (String, UIImage?)) {
        self.index = indexPath.row
        projectID = project.0
        projectButton.setImage(project.1, for: .normal)
        isChoosen = projectID == todo?.projectID
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.projectCategoryCell(self, index: index ?? 0)
    }
}
