//
//  BaseCollectionReusableView.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/22.
//

import UIKit

open class BaseCollectionReusableView: UICollectionReusableView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func configureAttributes() {}
    open func configureLayout() {}
}

extension BaseCollectionReusableView: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
