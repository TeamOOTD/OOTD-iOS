//
//  TodoCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/14.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

final class TodoCell: BaseCollectionViewCell {
    
    private let checkBoxButton = UIButton()
    private let contentLabel = UILabel()
    private lazy var tagHStackView = UIStackView()
    private let optionButton = UIImageView()
    
    var tags: [(String, UIColor)] = [] {
        didSet { createTagView(with: tags) }
    }
    
    override func configureAttributes() {
        checkBoxButton.do {
            $0.setImage(.icnCheckBox, for: .normal)
        }
        
        contentLabel.do {
            $0.text = "알고리즘 문제 풀이"
            $0.textColor = .grey900
            $0.font = .ootdFont(.regular, size: 14)
        }
        
        optionButton.do {
            $0.image = .icnOption
        }
        
        tagHStackView.do {
            $0.spacing = 4
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(checkBoxButton, contentLabel, tagHStackView, optionButton)
        
        checkBoxButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Spacing.s20)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(Spacing.s4)
            $0.centerY.equalTo(checkBoxButton.snp.centerY)
        }
        
        tagHStackView.snp.makeConstraints {
            $0.leading.equalTo(contentLabel.snp.trailing).offset(Spacing.s8)
            $0.centerY.equalTo(contentLabel.snp.centerY)
        }
        
        optionButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(Spacing.s20)
            $0.centerY.equalToSuperview()
        }
    }
}

extension TodoCell {
    
    private func createTagView(with tags: [(String, UIColor)]) {
        tags.forEach { tag in
            let tagView = ODSTagView()
            tagView.content = tag.0
            tagView.backgroundColor = tag.1
            tagHStackView.addArrangedSubview(tagView)
        }
    }
}
