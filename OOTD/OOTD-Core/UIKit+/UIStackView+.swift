//
//  UIStackView+.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/12.
//

import UIKit

extension UIStackView {
    
    public func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
