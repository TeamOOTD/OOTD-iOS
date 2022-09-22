//
//  LogoCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

protocol LogoCellDelegate: AnyObject {
    func logoAddButtonTapped(_ cell: LogoCell)
}

final class LogoCell: BaseCollectionViewCell {

    lazy var button = UIButton()
    
    weak var delegate: LogoCellDelegate?

    override func configureAttributes() {
        backgroundColor = .clear
        
        button.do {
            $0.makeRounded(radius: 4)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.grey500.cgColor
            $0.setImage(.icnCamera?.resized(side: 18).withTintColor(.grey600), for: .normal)
            $0.addTarget(self, action: #selector(logoAddButtonTapped), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension LogoCell {
    
    @objc func logoAddButtonTapped(_ sender: UIButton) {
        delegate?.logoAddButtonTapped(self)
    }
}
