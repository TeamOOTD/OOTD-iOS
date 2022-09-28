//
//  SettingCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class SettingCell: BaseCollectionViewCell {

    let titleLabel = UILabel()
    let descLabel = UILabel()
    let lineView = UIView()

    override func configureAttributes() {
        backgroundColor = .clear
        
        titleLabel.do {
            $0.textColor = .grey800
            $0.font = .ootdFont(.medium, size: 14)
        }
        
        descLabel.do {
            $0.text = "test"
            $0.textColor = .grey500
            $0.font = .ootdFont(.medium, size: 12)
        }
        
        lineView.do {
            $0.backgroundColor = .grey300
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(titleLabel, descLabel, lineView)
        
        titleLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(Spacing.s4)
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s24)
        }
        
        descLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(Spacing.s24)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s24)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SettingCell {
    
    func configure(_ title: String, desc: String? = nil) {
        titleLabel.text = title
        descLabel.text = desc
    }
}
