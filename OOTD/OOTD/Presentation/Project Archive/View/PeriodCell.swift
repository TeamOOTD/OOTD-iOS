//
//  PeriodCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

protocol PeriodCellDelegate: AnyObject {
    func startDateButtonTapped(_ cell: PeriodCell)
    func endDateButtonTapped(_ cell: PeriodCell)
}

final class PeriodCell: BaseCollectionViewCell {

    lazy var buttonHStackView = UIStackView(arrangedSubviews: [startDateButton, endDateButton])
    lazy var startDateButton = UIButton()
    lazy var endDateButton = UIButton()
    
    weak var delegate: PeriodCellDelegate?
    
    private lazy var dateFormatter = DateFormatter()
    
    var startDate: Date? {
        didSet {
            endDateButton.isHidden = startDate == nil
            guard let startDate else { return }
            startDateButton.setTitle(dateFormatter.string(from: startDate), for: .normal)
        }
    }
    var endDate: Date?

    override func configureAttributes() {
        backgroundColor = .clear
        
        dateFormatter.do {
            $0.dateFormat = "YYYY.MM.dd"
            $0.locale = Locale(identifier: "ko_KR")
            $0.timeZone = TimeZone(identifier: "ko_KR")
        }
        
        buttonHStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = Spacing.s8
        }
        
        startDateButton.do {
            $0.setTitle("시작일", for: .normal)
            $0.setTitleColor(.grey500, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.makeRounded(radius: 4)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.grey500.cgColor
            $0.addTarget(self, action: #selector(startDateButtonTapped), for: .touchUpInside)
        }
        
        endDateButton.do {
            $0.isHidden = true
            $0.setTitle("종료일", for: .normal)
            $0.setTitleColor(.grey500, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.makeRounded(radius: 4)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.grey500.cgColor
            $0.addTarget(self, action: #selector(endDateButtonTapped), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        contentView.addSubview(buttonHStackView)
        
        buttonHStackView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        startDateButton.snp.makeConstraints {
            $0.width.equalTo(120.adjustedWidth)
        }
        
        endDateButton.snp.makeConstraints {
            $0.width.equalTo(120.adjustedWidth)
        }
    }
}

extension PeriodCell {
    
    @objc func startDateButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func endDateButtonTapped(_ sender: UIButton) {
        
    }
}
