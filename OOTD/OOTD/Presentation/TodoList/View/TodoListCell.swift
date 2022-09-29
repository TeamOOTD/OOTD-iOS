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

protocol TodoListCellDelegate: AnyObject {
    func checkBoxButtonTapped(_ cell: TodoListCell, at indexPath: IndexPath)
}

final class TodoListCell: BaseCollectionViewCell {
    
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
    
    weak var delegate: TodoListCellDelegate?
    
    // MARK: - Override Functions
    
    override func configureAttributes() {
        checkBoxButton.do {
            $0.setImage(.icnCheckBox, for: .normal)
            $0.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        }
        
        contentLabel.do {
            $0.text = "오늘 날짜 리스트 표시 안되는 이슈 수"
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
        
        optionButton.snp.makeConstraints {
            $0.size.equalTo(24.adjustedWidth)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(Spacing.s4)
            $0.centerY.equalTo(checkBoxButton.snp.centerY)
            $0.trailing.equalTo(optionButton.snp.leading).offset(-80)
        }
        
        tagHStackView.snp.makeConstraints {
            $0.leading.equalTo(contentLabel.snp.trailing).offset(Spacing.s8)
            $0.centerY.equalTo(contentLabel.snp.centerY)
        }
    }
}

// MARK: - Private Functions

extension TodoListCell {
    
    @objc private func checkBoxButtonTapped(_ sender: UIButton) {
        isChecked.toggle()
        delegate?.checkBoxButtonTapped(self, at: index)
    }
}

// MARK: - Public Functions

extension TodoListCell {
    
    func configure(with data: Todo, at index: IndexPath) {
        self.index = index
        
        isChecked = data.isDone
        contentLabel.text = data.contents

        let priority = Priority.allCases[data.priority]
        tags.removeAll()
        if data.priority != 3 {
            tags.append(("중요도 " + priority.rawValue, priority.color))
        }
    }
    
    private func createTagView(with tags: [(String, UIColor)]) {
        tagHStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        tags.forEach { tag in
            let tagView = ODSTagView()
            tagView.content = tag.0
            tagView.backgroundColor = tag.1
            tagHStackView.addArrangedSubview(tagView)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        TodoListCell().showPreview(.iPhone13Mini)
    }
}
#endif
