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
    
    private lazy var headerView = TodoCalendarHeaderView()
    private lazy var scrollView = UIScrollView()
    private lazy var containerStackView = UIStackView()
    private let calendarView = FSCalendar()
    private let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        view.backgroundColor = .systemBackground
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
        
        containerStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = Spacing.s16
        }
        
        configureCollectionView()
    }
    
    override func configureLayout() {
        view.addSubviews(headerView, scrollView)
        scrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubviews(calendarView, collectionView)
        
        headerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s16)
            $0.height.equalTo(280.adjustedHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
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
    
    private func configureCollectionView() {
        collectionView.register(
            TodoHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TodoHeaderView.reuseIdentifier
        )
        
        collectionView.register(
            TodoCell.self,
            forCellWithReuseIdentifier: TodoCell.reuseIdentifier
        )
        
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.date = date
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        date = calendar.currentPage
        calendar.select(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [.green800, .yellow800]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let commitColor: UIColor = [UIColor.green800, UIColor.green600].randomElement()!.withAlphaComponent(0.5 * CGFloat.random(in: 1...2))
        let yellowColor: UIColor = [UIColor.yellow800, UIColor.yellow600].randomElement()!.withAlphaComponent(0.5 * CGFloat.random(in: 1...2))
        
        return [commitColor, yellowColor]
    }
}

extension TodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TodoHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TodoHeaderView else {
            return UICollectionReusableView()
        }

        return headerView
    }
}

extension TodoViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [generateHeader()]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return headerElement
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        TabBarController().showPreview(.iPhone13Mini)
    }
}
#endif
