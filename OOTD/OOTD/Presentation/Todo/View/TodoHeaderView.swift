//
//  TodoHeaderView.swift
//  OOTD
//
//  Created by taekki on 2022/09/14.
//

import UIKit

import SnapKit
import Then
import OOTD_UIKit

final class TodoHeaderView: UICollectionReusableView {

    private let titleLabel = UILabel()
    private let createButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TodoHeaderView {
    
    private func configureAttributes() {
        titleLabel.do {
            $0.text = "🌱 오늘의 할 일"
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 18)
        }
        
        createButton.do {
            $0.setImage(.icnPlusCircle, for: .normal)
        }
    }
    
    private func configureLayout() {
        addSubviews(titleLabel, createButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Spacing.s20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        createButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(Spacing.s4)
            $0.size.equalTo(48)
        }
    }
}
