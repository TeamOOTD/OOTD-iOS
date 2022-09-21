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

protocol TodoCellDelegate: AnyObject {
    func checkBoxButtonTapped(_ cell: TodoCell, at indexPath: IndexPath)
}

final class TodoCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private lazy var checkBoxButton = UIButton()
    private let contentLabel = UILabel()
    private lazy var tagHStackView = UIStackView()
    private let optionButton = UIImageView()
    
    // MARK: - Properties
    
    var index: IndexPath!
    
    var tags: [(String, UIColor)] = [] {
        didSet { createTagView(with: tags) }
    }
    
    var isChecked: Bool = false {
        didSet { checkBoxButton.setImage(isChecked ? .icnCheckBoxFill :  .icnCheckBox, for: .normal) }
    }
    
    weak var delegate: TodoCellDelegate?
    
    // MARK: - Override Functions
    
    override func configureAttributes() {
        checkBoxButton.do {
            $0.setImage(.icnCheckBox, for: .normal)
            $0.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
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
            $0.leading.equalToSuperview()
            $0.size.equalTo(24.adjustedWidth)
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
            $0.size.equalTo(24.adjustedWidth)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Private Functions

extension TodoCell {
    
    @objc private func checkBoxButtonTapped(_ sender: UIButton) {
        isChecked.toggle()
        delegate?.checkBoxButtonTapped(self, at: index)
    }
}

// MARK: - Public Functions

extension TodoCell {
    
    func configure(with data: Todo, at index: IndexPath) {
        self.index = index
        
        isChecked = data.isDone
        contentLabel.text = data.contents
    }
    
    private func createTagView(with tags: [(String, UIColor)]) {
        tags.forEach { tag in
            let tagView = ODSTagView()
            tagView.content = tag.0
            tagView.backgroundColor = tag.1
            tagHStackView.addArrangedSubview(tagView)
        }
    }
}
