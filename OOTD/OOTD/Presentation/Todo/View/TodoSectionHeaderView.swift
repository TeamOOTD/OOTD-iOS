//
//  TodoSectionHeaderView.swift
//  OOTD
//
//  Created by taekki on 2022/09/14.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

protocol TodoSectionHeaderViewDelegate: AnyObject {
    func todoSectionHeaderViewCreateButtonTapped(_ todoHeaderView: TodoSectionHeaderView)
}

extension TodoSectionHeaderViewDelegate {
    func todoSectionHeaderViewCreateButtonTapped(_ todoHeaderView: TodoSectionHeaderView) {}
}

final class TodoSectionHeaderView: BaseCollectionReusableView {
    
    // MARK: - UI Properties

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var createButton = UIButton()
    
    // MARK: - Properties
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var rightIcon: UIImage? {
        get { createButton.currentImage }
        set { createButton.setImage(newValue, for: .normal) }
    }
    
    weak var delegate: TodoSectionHeaderViewDelegate?
    
    // MARK: - Override Functions
    
    override func configureAttributes() {
        titleLabel.do {
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 18)
        }
        
        createButton.do {
            $0.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        addSubviews(titleLabel, createButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24.adjustedHeight)
        }
        
        createButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    }
}

// MARK: - Private Functions

extension TodoSectionHeaderView {

    @objc private func createButtonDidTap(_ sender: UIButton) {
        delegate?.todoSectionHeaderViewCreateButtonTapped(self)
    }
}
