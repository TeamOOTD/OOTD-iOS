//
//  Adjusted+.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/12.
//

import UIKit

/*
 - iPhone 13 mini (375x812 기준)
 */

extension CGFloat {
    public var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    public var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}

extension Double {
    public var adjustedWidth: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    public var adjustedHeight: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 812)
        return self * ratio
    }
}
