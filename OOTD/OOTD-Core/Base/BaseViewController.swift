//
//  BaseViewController.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/12.
//

import UIKit

open class BaseViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
        bind()
    }

    open func configureAttributes() {
        navigationController?.navigationBar.isHidden = true
    }
    open func configureLayout() {}
    open func bind() {}
}
