//
//  TodoHeaderView.swift
//  OOTD
//
//  Created by taekki on 2022/09/14.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

protocol TodoHeaderViewDelegate: AnyObject {
    func todoHeaderViewCreateButtonDidTap(_ todoHeaderView: TodoHeaderView)
}

extension TodoHeaderViewDelegate {
    func todoHeaderViewCreateButtonDidTap(_ todoHeaderView: TodoHeaderView) {}
}

final class TodoHeaderView: UICollectionReusableView, Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var createButton = UIButton()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var rightIcon: UIImage? {
        get { createButton.currentImage }
        set { createButton.setImage(newValue, for: .normal) }
    }
    
    weak var delegate: TodoHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TodoHeaderView {
    
    private func configureAttributes() {
        titleLabel.do {
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 18)
        }
        
        createButton.do {
            $0.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        }
    }
    
    private func configureLayout() {
        addSubviews(titleLabel, createButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        createButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    }
    
    @objc func createButtonDidTap(_ sender: UIButton) {
        delegate?.todoHeaderViewCreateButtonDidTap(self)
    }
}
