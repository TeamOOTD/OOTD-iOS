//
//  SectionHeaderView.swift
//  OOTD
//
//  Created by taekki on 2022/09/14.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

protocol SectionHeaderViewDelegate: AnyObject {
    func sectionHeaderViewCreateButtonTapped(_ todoHeaderView: SectionHeaderView)
}

final class SectionHeaderView: BaseCollectionReusableView {
    
    // MARK: - UI Properties

    private let titleLabel = UILabel()
    private let asteriskLabel = UILabel()
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
    
    var isNecessary: Bool {
        get { asteriskLabel.isHidden }
        set { asteriskLabel.isHidden = !newValue }
    }
    
    weak var delegate: SectionHeaderViewDelegate?
    
    // MARK: - Override Functions
    
    override func configureAttributes() {
        titleLabel.do {
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 18)
        }
        
        asteriskLabel.do {
            $0.text = "*"
            $0.textColor = .red
            $0.font = .ootdFont(.bold, size: 18)
            $0.isHidden = true
        }
        
        createButton.do {
            $0.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        addSubviews(titleLabel, asteriskLabel, createButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24.adjustedHeight)
        }
        
        asteriskLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        createButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    }
}

// MARK: - Private Functions

extension SectionHeaderView {

    @objc private func createButtonDidTap(_ sender: UIButton) {
        delegate?.sectionHeaderViewCreateButtonTapped(self)
    }
}
