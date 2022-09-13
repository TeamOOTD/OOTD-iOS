//
//  ODSTextField.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/13.
//

import UIKit

import SnapKit
import Then
import OOTD_Core

public final class ODSTextField: UITextField {

    public var borderSize: CGFloat = 2.0 {
        didSet { updateBorder() }
    }

    public var activeBorderColor: UIColor = .grey900 {
        didSet { updateBorder() }
    }
    
    public var inactiveBorderColor: UIColor = .grey500 {
        didSet { updateBorder() }
    }

    public var cornerRadius: CGFloat = Radii.r5 {
        didSet { updateBorder() }
    }
    
    public var titleText: String? {
        didSet { updatePlaceholder() }
    }

    public var placeholderText: String? {
        didSet { updatePlaceholder() }
    }

    public var placeholderColor: UIColor? = .grey500 {
        didSet { updatePlaceholder() }
    }
    
    public var cursorColor: UIColor = .grey900 {
        didSet { updatePlaceholder() }
    }
    
    private var inset: CGFloat = Spacing.s8
    private lazy var commonInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

    private let clearButtonOffset: CGFloat = Spacing.s8
    private let clearButtonLeftPadding: CGFloat = Spacing.s8

    private lazy var placeholderLabel = UILabel().then {
        $0.text = titleText
        $0.textColor = .grey500
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitial()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholderText = placeholder
    }
    
    private func configureInitial() {
        delegate = self
        configureAttributes()
        updateBorder()
        updatePlaceholder()
    }
    
    private func configureAttributes() {
        placeholder = ""
        clearButtonMode = .whileEditing
        tintColor = cursorColor
    }
    
    private func configureLayout() {
        self.superview?.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(Spacing.s8)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }

    private func updateBorder() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderSize
        layer.borderColor = isFirstResponder || hasText ? activeBorderColor.cgColor : inactiveBorderColor.cgColor
    }
    
    private func updatePlaceholder() {
        guard let titleText = titleText else { return }
        placeholderLabel.text = titleText
        placeholderLabel.font = .ootdFont(.regular, size: 14)
        placeholderLabel.backgroundColor = titleText.isEmpty ? UIColor.clear : .white
        placeholder = isFirstResponder ? placeholderText : ""
    }
}

extension ODSTextField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder()
        updatePlaceholder()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder()
        updatePlaceholder()
    }
}

extension ODSTextField {
    
    public override func didMoveToSuperview() {
        configureLayout()
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: commonInsets.top,
            left: commonInsets.left,
            bottom: commonInsets.bottom,
            right: clearButtonWidth + clearButtonOffset + clearButtonLeftPadding
        )
        return bounds.inset(by: editingInsets)
    }
    
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset
        return clearButtonRect
    }
}
