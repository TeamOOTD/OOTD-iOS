//
//  ODSButton.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/13.
//

import UIKit

import SnapKit
import Then
import OOTD_Core

public final class ODSButton: BaseView {
    
    public var button = UIButton()
    
    public enum ButtonState {
        case enabled
        case sub
        case disabled
        
        var backgroundColor: UIColor? {
            switch self {
            case .enabled:  return .green800
            case .sub:      return .green600
            case .disabled: return .grey200
            }
        }
        
        var titleColor: UIColor? {
            switch self {
            case .enabled, .sub: return .white
            case .disabled:      return .grey300
            }
        }
        
        var isEnabled: Bool {
            switch self {
            case .enabled, .sub: return true
            case .disabled:      return false
            }
        }
    }
    
    public var title: String? {
        get { button.titleLabel?.text }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    public var buttonState: ButtonState {
        didSet {
            updateUI(buttonState)
        }
    }
    
    public init(_ buttonState: ButtonState) {
        self.buttonState = buttonState
        super.init(frame: .zero)
        updateUI(buttonState)
    }
    
    public override func configureAttributes() {
        makeRounded(radius: Radii.r4)
        
        button.do {
            $0.titleLabel?.font = .ootdFont(.bold, size: 18)
        }
    }
    
    public override func configureLayout() {
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateUI(_ buttonState: ButtonState) {
        button.backgroundColor = buttonState.backgroundColor
        button.setTitleColor(buttonState.titleColor, for: .normal)
        button.isEnabled = buttonState.isEnabled
    }
}

