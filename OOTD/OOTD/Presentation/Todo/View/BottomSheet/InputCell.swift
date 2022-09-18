//
//  InputCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

final class InputCell: BaseCollectionViewCell {
    
    let textField = ODSTextField()
    
    override func configureAttributes() {
        backgroundColor = .clear
    }
    
    override func configureLayout() {
        contentView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
