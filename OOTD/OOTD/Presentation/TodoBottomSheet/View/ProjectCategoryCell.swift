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
            projectButton.layer.borderColor = isChoosen ? UIColor.yellow800.cgColor : UIColor.grey200.cgColor
        }
    }
    
    override func configureAttributes() {
        backgroundColor = .clear
        projectButton.makeRounded(radius: 32)
        projectButton.layer.borderWidth = 3
        projectButton.layer.borderColor = UIColor.grey200.cgColor
        
        projectButton.do {
            $0.setTitle("없음", for: .normal)
            $0.setTitleColor(.grey600, for: .normal)
            $0.titleLabel?.font = .ootdFont(.regular, size: 14)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

        titleLabel.do {
            $0.textColor = .grey600
            $0.font = .ootdFont(.regular, size: 14)
            $0.textAlignment = .center
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(titleLabel, projectButton)
        
        projectButton.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.size.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(projectButton.snp.bottom).offset(4)
            $0.centerX.equalTo(projectButton)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        projectButton.setImage(nil, for: .normal)
        projectID = ""
        titleLabel.text = ""
    }
}

extension ProjectCategoryCell {
    
    func configure(at indexPath: IndexPath, with todo: Todo?, project: (Project, UIImage?)) {
        self.index = indexPath.row
        projectID = project.0.id
        projectButton.setImage(project.1, for: .normal)
        titleLabel.text = project.0.name
        isChoosen = projectID == todo?.projectID
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.projectCategoryCell(self, index: index ?? 0)
    }
}
