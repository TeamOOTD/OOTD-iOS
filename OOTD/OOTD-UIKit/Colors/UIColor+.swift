//
//  UIColor+.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/12.
//

import UIKit

extension UIColor {
    
    public static func makeColor(from hex: String) -> UIColor {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >>  8) & 0xFF) / 255.0
        let blue = Double((rgb >>  0) & 0xFF) / 255.0
        
        return .init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    
    // MARK: - Main Colors
    
    public static let yellow800 = makeColor(from: "#FFCB67")
    public static let yellow600 = makeColor(from: "#F5E1A4")
    public static let green800 = makeColor(from: "#7AA081")
    public static let green600 = makeColor(from: "#E7EDC8")
    
    // MARK: - Block Colors
    
    public static let algorithm = makeColor(from: "#E5E3C9")
    public static let commit = makeColor(from: "#B4CFB0")
    public static let blog = makeColor(from: "#94B49F")
    public static let study = makeColor(from: "#789395")
    
    // MARK: - Grey Scale
    
    public static let grey900 = makeColor(from: "#262626")
    public static let grey800 = makeColor(from: "#4D4D4D")
    public static let grey700 = makeColor(from: "#666666")
    public static let grey600 = makeColor(from: "#808080")
    public static let grey500 = makeColor(from: "#999999")
    public static let grey400 = makeColor(from: "#B3B3B3")
    public static let grey300 = makeColor(from: "#CCCCCC")
    public static let grey200 = makeColor(from: "#E6E6E6")
    public static let grey100 = makeColor(from: "#FAFAFA")
}
