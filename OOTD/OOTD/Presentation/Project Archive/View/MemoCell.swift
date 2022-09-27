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
import RxSwift

protocol MemoCellDelegate: AnyObject {
    func textViewHeightDidChange(_ cell: MemoCell)
}

final class MemoCell: BaseCollectionViewCell {

    lazy var placeholderLabel = UILabel()
    let textView = UITextView()
    
    weak var delegate: MemoCellDelegate?
    var disposedBag = DisposeBag()
    
    var text: String? {
        didSet {
            if text != "" {
                textView.text = text
                textView.textColor = .grey900
                placeholderLabel.textColor = .clear
            }
        }
    }
    
    var textViewPlaceHolder: String? {
        didSet {
            placeholderLabel.text = textViewPlaceHolder
        }
    }

    override func configureAttributes() {
        backgroundColor = .clear
        
        placeholderLabel.do {
            $0.textColor = .grey400
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 14)
        }
        
        textView.do {
            $0.backgroundColor = .clear
            $0.makeRounded(radius: 4)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.grey500.cgColor
            $0.textColor = .grey400
            $0.font = .systemFont(ofSize: 14)
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            $0.delegate = self
            $0.autocorrectionType = .no
            $0.isScrollEnabled = false
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(placeholderLabel, textView)
        
        placeholderLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
        }
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MemoCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .grey900
        placeholderLabel.textColor = .clear
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            placeholderLabel.textColor = .grey400
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewHeightDidChange(self)
    }
}
