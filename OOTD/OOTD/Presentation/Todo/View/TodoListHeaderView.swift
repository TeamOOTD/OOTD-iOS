//
//  TodoListHeaderView.swift
//  OOTD
//
//  Created by taekki on 2022/09/14.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class TodoListHeaderView: BaseView {
    
    // MARK: - UI Properties
    
    private let dateLabel = UILabel()
    private let commitDotView = UIView()
    private let commitLabel = UILabel()
    private let todoRateView = UIView()
    private let todoRateLabel = UILabel()
    
    // MARK: - Properties
    
    var date: String? {
        didSet { dateTitle = date }
    }
    
    var commitCount: Int = 0 {
        didSet { commitTitle = "\(commitCount) 커밋" }
    }
    
    var todoPercent: Int = 0 {
        didSet { todoTitle = "투두 \(todoPercent)% 달성" }
    }
    
    private var dateTitle: String? {
        get { dateLabel.text }
        set { dateLabel.text = newValue }
    }
    
    private var commitTitle: String? {
        get { commitLabel.text }
        set { commitLabel.text = newValue }
    }
    
    private var todoTitle: String? {
        get { todoRateLabel.text }
        set { todoRateLabel.text = newValue }
    }
    
    // MARK: - Override Functions
    
    override func configureAttributes() {
        dateLabel.do {
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 24)
        }
        
        commitDotView.do {
            $0.backgroundColor = .green800
        }
        
        commitLabel.do {
            $0.textColor = .grey700
            $0.font = .ootdFont(.medium, size: 10)
        }
        
        todoRateView.do {
            $0.backgroundColor = .yellow800
        }
        
        todoRateLabel.do {
            $0.textColor = .grey700
            $0.font = .ootdFont(.medium, size: 10)
        }
    }
    
    override func configureLayout() {
        addSubviews(dateLabel, commitDotView, commitLabel, todoRateView, todoRateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Spacing.s8)
            $0.leading.equalToSuperview().inset(Spacing.s20)
        }
        
        commitDotView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(Spacing.s8)
            $0.leading.equalToSuperview().inset(Spacing.s20)
            $0.size.equalTo(8.adjustedWidth)
        }
        
        commitLabel.snp.makeConstraints {
            $0.centerY.equalTo(commitDotView.snp.centerY)
            $0.leading.equalTo(commitDotView.snp.trailing).offset(Spacing.s4)
        }
        
        todoRateView.snp.makeConstraints {
            $0.centerY.equalTo(commitDotView.snp.centerY)
            $0.leading.equalTo(commitLabel.snp.trailing).offset(Spacing.s8)
            $0.size.equalTo(8.adjustedWidth)
        }
        
        todoRateLabel.snp.makeConstraints {
            $0.centerY.equalTo(commitDotView.snp.centerY)
            $0.leading.equalTo(todoRateView.snp.trailing).offset(Spacing.s4)
        }
    }
}
