//
//  TodoViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import FSCalendar
import OOTD_Core
import OOTD_UIKit

final class TodoViewController: BaseViewController {
    
    lazy var headerView = TodoCalendarHeaderView()
    let calendarView = FSCalendar()
    
    private let dateFormatter = DateFormatter()
    
    private var date = Date() {
        didSet { headerView.date = dateFormatter.string(from: date) }
    }
    
    private var commitCount = 0 {
        didSet { headerView.commitCount = commitCount }
    }
    
    private var todoPercent = 0 {
        didSet { headerView.todoPercent = todoPercent }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureAttributes() {
        configureCalendarView()
        
        dateFormatter.do {
            $0.dateFormat = "YYYY년 M월 d일"
            $0.locale = Locale(identifier: "ko_KR")
            $0.timeZone = TimeZone(identifier: "ko_KR")
        }
        
        headerView.do {
            $0.date = dateFormatter.string(from: date)
            $0.commitCount = commitCount
            $0.todoPercent = todoPercent
        }
    }
    
    override func configureLayout() {
        view.addSubviews(headerView, calendarView)
        
        headerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Spacing.s8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s16)
            $0.height.equalTo(280.adjustedHeight)
        }
    }
}

extension TodoViewController {
    
    private func configureCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.select(Date())
        calendarView.headerHeight = 0
        calendarView.firstWeekday = 2
        calendarView.placeholderType = .fillHeadTail
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.weekdayTextColor = .grey700
        calendarView.appearance.titleDefaultColor = .grey700
        calendarView.appearance.titleTodayColor = .grey700
        calendarView.appearance.titleSelectionColor = .yellow800
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.weekdayFont = .ootdFont(.regular, size: 10)
        calendarView.appearance.titleFont = .ootdFont(.medium, size: 14)
        calendarView.appearance.selectionColor = .clear
    }
}

extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.date = date
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        date = calendar.currentPage
        calendar.select(date)
    }
}
