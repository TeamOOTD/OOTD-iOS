//
//  InputCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit
import RxSwift

final class InputCell: BaseCollectionViewCell {

    lazy var textField = ODSTextField()
    
    var disposedBag = DisposeBag()
    
    var handler: ((String?) -> Void)?
    
    override func configureAttributes() {
        backgroundColor = .clear
        
        textField.do {
            $0.font = .systemFont(ofSize: 14)
        }
    }
    
    override func configureLayout() {
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        handler?(textField.text)
    }
}
