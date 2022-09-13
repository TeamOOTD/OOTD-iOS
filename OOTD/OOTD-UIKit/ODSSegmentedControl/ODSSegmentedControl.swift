//
//  ODSSegmentedControl.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/13.
//

import UIKit

import SnapKit
import Then
import OOTD_Core

public protocol ODSSegmentedControlDelegate: AnyObject {
    func segmentedControl(_ segmentedControl: ODSSegmentedControl, to index:Int)
}

public final class ODSSegmentedControl: BaseView {
 
    private var buttonTitles = [String]()
    private var buttons = [UIButton]()
    private var selectorView = UIView()
    
    public var textColor: UIColor = .grey900
    public var selectorViewColor: UIColor = .yellow800
    
    public private(set) var selectedIndex = 0
    
    public weak var delegate: ODSSegmentedControlDelegate?
    
    public init(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        super.init(frame: .zero)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }

    @objc func didSwitched(_ sender: ODSSegmentedControl) {
        for (index, button) in buttons.enumerated() {
            if button == sender && selectedIndex != index {
                button.setTitleColor(textColor, for: .normal)
                selectedIndex = index
                delegate?.segmentedControl(self, to: selectedIndex)
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
                UIView.animate(withDuration: 0.2) {
                    self.selectorView.frame.origin.x = selectorPosition + Spacing.s4
                }
                
            }
        }
    }
}

extension ODSSegmentedControl {
    
    private func updateView() {
        makeRounded(radius: Radii.r4)
        createButton()
        configureSelectorView()
        configureStackView()
    }
    
    private func createButton() {
        for buttonTitle in buttonTitles {
            let button = UIButton()
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .ootdFont(.medium, size: 12)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(didSwitched), for: .touchUpInside)
            buttons.append(button)
        }
    }
    
    private func configureSelectorView() {
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selectorView = UIView(frame: CGRect(
            x: Spacing.s4, y: Spacing.s4,
            width: selectorWidth - Spacing.s4 * 2,
            height: self.frame.height - Spacing.s4 * 2
        ))
        selectorView.backgroundColor = selectorViewColor
        selectorView.makeRounded(radius: Radii.r4)
        addSubview(selectorView)
    }
    
    private func configureStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
