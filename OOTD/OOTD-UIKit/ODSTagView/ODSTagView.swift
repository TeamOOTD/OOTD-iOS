//
//  ODSTagView.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/13.
//

import UIKit

import SnapKit
import Then
import OOTD_Core

public final class ODSTagView: BaseView {
    
    private let contentLabel = UILabel()
    
    public var content: String? {
        get { contentLabel.text }
        set { contentLabel.text = newValue }
    }
    
    public override func configureAttributes() {
        makeRounded(radius: Radii.r2)
        
        contentLabel.do {
            $0.textColor = .white
            $0.font = .ootdFont(.bold, size: 8)
        }
    }
    
    public override func configureLayout() {
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Spacing.s4)
        }
    }
}
