//
//  UIViewController+.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/21.
//

import UIKit

extension UIViewController {
    
    public func presentAlert (
        title: String,
        message: String? = nil,
        isIncludedCancel: Bool = false,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isIncludedCancel {
            let deleteAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(deleteAction)
        }

        let okAction = UIAlertAction(title: "확인", style: .default, handler: completion)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
