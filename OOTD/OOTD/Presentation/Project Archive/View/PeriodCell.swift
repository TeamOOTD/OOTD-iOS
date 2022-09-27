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
import RxSwift

protocol PeriodCellDelegate: AnyObject {
    func startDateButtonTapped(_ cell: PeriodCell, date: Date?)
    func endDateButtonTapped(_ cell: PeriodCell, date: Date?)
}

final class PeriodCell: BaseCollectionViewCell {

    lazy var buttonHStackView = UIStackView(arrangedSubviews: [startDateButton, endDateButton])
    lazy var startDateButton = UIButton()
    lazy var endDateButton = UIButton()
    
    var viewModel: ProjectArchiveCollectionViewAdapterDataSource?
    weak var delegate: PeriodCellDelegate?
    var disposedBag = DisposeBag()
    
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
        
        addObserver()
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
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStartDate), name: NSNotification.Name("startDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEndDate), name: NSNotification.Name("endDate"), object: nil)
    }
    
    @objc func handleStartDate(_ noti: Notification) {
        if let startDate = noti.userInfo?["selectedDate"] as? Date {
            let startDateString = dateFormatter.string(from: startDate)
            self.startDate = startDate
            startDateButton.setTitle(startDateString, for: .normal)
            endDateButton.isHidden = false
            viewModel?.startDate.accept(startDate)
        }
    }
    
    @objc func handleEndDate(_ noti: Notification) {
        if let endDate = noti.userInfo?["selectedDate"] as? Date {
            let endDateString = dateFormatter.string(from: endDate)
            self.endDate = endDate
            endDateButton.setTitle(endDateString, for: .normal)
            viewModel?.endDate.accept(endDate)
        } else {
            endDateButton.setTitle("진행 중", for: .normal)
        }
    }
    
    @objc func startDateButtonTapped(_ sender: UIButton) {
        delegate?.startDateButtonTapped(self, date: startDate)
    }
    
    @objc func endDateButtonTapped(_ sender: UIButton) {
        delegate?.endDateButtonTapped(self, date: endDate)
    }
    
    func bind(_ viewModel: ProjectArchiveCollectionViewAdapterDataSource) {
        self.viewModel = viewModel
        
        if let startDate = viewModel.startDate.value {
            self.startDate = startDate
            endDateButton.isHidden = false
        }
        
        if let endDate = viewModel.endDate.value {
            let endDateString = dateFormatter.string(from: endDate)
            self.endDate = endDate
            endDateButton.setTitle(endDateString, for: .normal)
        } else {
            endDateButton.setTitle("진행 중", for: .normal)
        }
    }
}
