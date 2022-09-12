//
//  ODSNavigationBar.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import SnapKit
import Then
import OOTD_Core

public final class ODSNavigationBar: BaseView {
 
    public let leftButton = UIButton()
    public let titleLabel = UILabel()
    public let rightButton = UIButton()
    
    private let navigationBarHeight: CGFloat = 44.0
    
    public enum BarItem {
        case back, close, add, timer
        
        var image: UIImage? {
            switch self {
            case .back:     return .icnBack
            case .close:    return .icnClose
            case .add:      return .icnAdd
            case .timer:    return .icnTimer
            }
        }
    }
    
    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var leftBarItem: BarItem? {
        didSet { leftButton.setImage(leftBarItem?.image, for: .normal) }
    }
    
    public var rightBarItem: BarItem? {
        didSet { rightButton.setImage(rightBarItem?.image, for: .normal) }
    }
    
    public var rightTitle: String? {
        didSet { rightButton.setTitle(rightTitle, for: .normal) }
    }
    
    public var isRightButtonEnabled = true {
        didSet {
            rightButton.isEnabled = isRightButtonEnabled
            rightButton.setTitleColor(isRightButtonEnabled ? .grey900 : .grey200, for: .normal)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: navigationBarHeight)
    }
    
    public override func configureAttributes() {
        titleLabel.do {
            $0.textColor = .grey800
            $0.font = .ootdFont(.bold, size: 18)
        }
        
        rightButton.do {
            $0.isEnabled = isRightButtonEnabled
            $0.setTitleColor(isRightButtonEnabled ? .grey900 : .grey200, for: .normal)
        }
    }
    
    public override func configureLayout() {
        addSubviews(leftButton, titleLabel, rightButton)
        
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Spacing.s16)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Spacing.s16)
            $0.centerY.equalToSuperview()
        }
    }
}
