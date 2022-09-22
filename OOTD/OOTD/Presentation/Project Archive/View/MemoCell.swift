//
//  MemoCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

final class MemoCell: BaseCollectionViewCell {

    lazy var textView = UITextView()
    
    var textViewPlaceHolder: String? {
        didSet {
            textView.text = textViewPlaceHolder
        }
    }

    override func configureAttributes() {
        backgroundColor = .clear
        
        textView.do {
            $0.makeRounded(radius: 4)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.grey500.cgColor
            $0.textColor = .grey400
            $0.text = textViewPlaceHolder
            $0.font = .systemFont(ofSize: 14)
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            $0.delegate = self
            $0.isScrollEnabled = false
        }
    }
    
    override func configureLayout() {
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MemoCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .grey900
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grey500
        }
    }
}
