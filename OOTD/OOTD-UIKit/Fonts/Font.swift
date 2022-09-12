//
//  Font.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/12.
//

import UIKit

public enum PretendardFontType: String, CaseIterable {
    case bold       = "Pretendard-Bold"
    case medium     = "Pretendard-Medium"
    case regular    = "Pretendard-Regular"
    case semibold   = "Pretendard-SemiBold"
    
    static var installed = false
}

public extension PretendardFontType {
    
    static func install() {
        PretendardFontType.installed = true
        
        for each in PretendardFontType.allCases {
            if let cfURL = ODSBundle.bundle.url(forResource: each.rawValue, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(cfURL as CFURL, .process, nil)
            } else {
                assertionFailure("Could not find font:\(each.rawValue) in bundle:\(ODSBundle.bundle)")
            }
        }
    }
}

extension UIFont {
    
    public static func ootdFont(_ fontType: PretendardFontType, size: CGFloat) -> UIFont {
        if PretendardFontType.installed == false {
            PretendardFontType.install()
        }
        return UIFont(name: fontType.rawValue, size:  size)!
    }
}
