//
//  UIView+.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/12.
//

import UIKit

extension UIView {
    
    public func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    public func makeRounded(_ corners: [UIRectCorner] = [.allCorners], radius: Double) {
        if corners != [.allCorners] {
            var cornerMask = CACornerMask()
            
            corners.forEach {
                if $0.contains(.topLeft) {
                    cornerMask.insert(.layerMinXMinYCorner)
                }
                if $0.contains(.topRight) {
                    cornerMask.insert(.layerMaxXMinYCorner)
                }
                if $0.contains(.bottomLeft) {
                    cornerMask.insert(.layerMinXMaxYCorner)
                }
                if $0.contains(.bottomRight) {
                    cornerMask.insert(.layerMaxXMaxYCorner)
                }
            }
            
            layer.maskedCorners = cornerMask
        }
        
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}
