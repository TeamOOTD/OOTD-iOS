//
//  BaseCollectionView.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/15.
//

import UIKit

open class BaseCollectionView: UICollectionView {
    
    open override var contentSize: CGSize {
        didSet {
            if oldValue.height != contentSize.height {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + 44)
    }
}
