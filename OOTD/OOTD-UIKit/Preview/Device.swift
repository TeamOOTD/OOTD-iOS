//
//  Device.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/13.
//

import Foundation

public enum Device: String {
    case iPhone8        = "iPhone 8"
    case iPhone13mini   = "iPhone 13 mini"
    case iPhone13ProMax = "iPhone 13 Pro max"
    case iPhone14Pro    = "iPhone 14 Pro"
}

extension Device: CustomStringConvertible {
    public var description: String { return rawValue }
}
