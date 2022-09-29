//
//  TagFieldCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/23.
//

import UIKit

import OOTD_Core
import OOTD_UIKit
import WSTagsField
import RxSwift

final class TagFieldCell: BaseCollectionViewCell {
    
    lazy var tagField = WSTagsField()

    override func configureAttributes() {
        super.configureAttributes()
        
        tagField.do {
            $0.makeRounded(radius: 4)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.grey500.cgColor
            $0.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
            $0.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.spaceBetweenLines = 10
            $0.spaceBetweenTags = 4
            $0.backgroundColor = .white
            $0.tintColor = .grey800
            $0.selectedColor = .yellow800
            $0.selectedTextColor = .white
            $0.placeholderAlwaysVisible = true
            $0.font = .systemFont(ofSize: 14)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        contentView.addSubview(tagField)
        
        tagField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension TagFieldCell {
    
    func configure(
        section: ProjectArchiveSection? = .member
    ) {
        tagField.placeholder = section == .member ? "ex. 멤버" : "ex. Swift"
    }
    
    func bind(
        _ viewModel: ProjectArchiveCollectionViewAdapterDataSource,
        section: ProjectArchiveSection? = .member
    ) {
        if section == .member {
            tagField.addTags(viewModel.member.value)
        } else {
            tagField.addTags(viewModel.tech.value)
        }

        tagField.onDidAddTag = { textField, _ in
            if section == .member {
                viewModel.member.accept(textField.tags.map { $0.text })
            } else {
                viewModel.tech.accept(textField.tags.map { $0.text })
            }
        }
        
        tagField.onDidRemoveTag = { textField, _ in
            if section == .member {
                viewModel.member.accept(textField.tags.map { $0.text })
            } else {
                viewModel.tech.accept(textField.tags.map { $0.text })
            }
        }
    }
}
