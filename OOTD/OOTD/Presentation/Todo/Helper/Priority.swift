//
//  Priority.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

enum Priority: String, CaseIterable {
    case high   = "상"
    case middle = "중"
    case row    = "하"
    case none   = "없음"
}

extension Priority {
    
    var color: UIColor {
        switch self {
        case .high:
            return .high
        case .middle:
            return .middle
        case .row:
            return .row
        case .none:
            return .grey300
        }
    }
}
