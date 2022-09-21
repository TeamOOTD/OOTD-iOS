//
//  TodoListViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import FSCalendar
import OOTD_Core
import OOTD_UIKit

final class TodoListViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let navigationBar = ODSNavigationBar()
    private let headerView = TodoListHeaderView()
    private let scopeSegmentedControl = ODSSegmentedControl(buttonTitles: ["주간", "월간"])
    private let scrollView = UIScrollView()
    private lazy var containerVStackView = UIStackView(arrangedSubviews: [calendarView, collectionView])
    private let calendarView = FSCalendar()
    private let collectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    
    private let viewModel = TodoListViewModel()
    private lazy var adapter = TodoListCollectionViewAdapter(
        collectionView: collectionView,
        adapterDataSource: viewModel,
        delegate: self
    )
    private let dateFormatter = DateFormatter()
    private var calendarHeight: CGFloat = 280.0.adjustedHeight

    // MARK: - Override Functions

    override func configureAttributes() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        dateFormatter.do {
            $0.dateFormat = "YYYY년 M월 d일"
            $0.locale = Locale(identifier: "ko_KR")
            $0.timeZone = TimeZone(identifier: "ko_KR")
        }
        
        scopeSegmentedControl.do {
            $0.delegate = self
            $0.selectorViewColor = .yellow600
            $0.backgroundColor = .green600
        }
        
        navigationBar.do {
            $0.rightBarItem = .timer
        }
        
        headerView.do {
            $0.date = dateFormatter.string(from: viewModel.currentDate.value)
            $0.commitCount = viewModel.commitCount.value
            $0.todoPercent = viewModel.todoPercent.value
        }

        containerVStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = Spacing.s16
        }
        
        calendarView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.select(Date())
            $0.setScope(.week, animated: false)
            $0.headerHeight = 0
            $0.firstWeekday = 2
            $0.placeholderType = .fillHeadTail
            $0.locale = Locale(identifier: "ko_KR")
            $0.appearance.weekdayTextColor = .grey700
            $0.appearance.titleDefaultColor = .grey700
            $0.appearance.titleTodayColor = .grey700
            $0.appearance.titleSelectionColor = .yellow800
            $0.appearance.todayColor = .clear
            $0.appearance.weekdayFont = .ootdFont(.regular, size: 10)
            $0.appearance.titleFont = .ootdFont(.medium, size: 14)
            $0.appearance.selectionColor = .clear
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
        }
    }
    
    override func configureLayout() {
        view.addSubviews(navigationBar, headerView, scopeSegmentedControl, scrollView)
        scrollView.addSubview(containerVStackView)
        
        navigationBar.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scopeSegmentedControl.snp.makeConstraints {
            $0.center.equalTo(navigationBar)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(24.adjustedHeight)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(scopeSegmentedControl.snp.bottom).offset(Spacing.s16)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(70.adjustedHeight)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        containerVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s16)
            $0.height.equalTo(calendarHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(Spacing.s24)
        }
    }
    
    override func bind() {
        adapter.adapterDataSource = viewModel
        viewModel.fetchTodos()
        
        viewModel.todos.bind { [weak self] _ in
            self?.viewModel.calculateTodoPercent()
            self?.collectionView.reloadData()
        }
        
        viewModel.currentDate.bind { [weak self] date in
            self?.headerView.date = self?.dateFormatter.string(from: date)
        }
        
        viewModel.commitCount.bind { [weak self] count in
            self?.headerView.commitCount = count
        }
        
        viewModel.todoPercent.bind { [weak self] percent in
            self?.headerView.todoPercent = percent
        }
    }
}

extension TodoListViewController: TodoListCollectionViewAdapterDelegate {
    func todoHeaderViewCreateButtonDidTap() {
        presentBottomSheetViewController()
    }
    
    func todoCheckBoxTapped(_ todo: Todo, at index: Int) {
        viewModel.updateTodo(item: todo)
        viewModel.fetchTodos()
    }
    
    private func presentBottomSheetViewController() {
        let viewModel = TodoBottomSheetViewModel()
        let todoBottomSheetViewController = TodoBottomSheetViewController(viewModel: viewModel)
        todoBottomSheetViewController.completionHandler = { [weak self] in
            self?.viewModel.fetchTodos()
        }
        present(todoBottomSheetViewController, animated: true)
    }
    
    func todoTapped(_ todo: Todo, at index: Int) {
        let viewModel = TodoBottomSheetViewModel(
            state: .edit,
            item: todo,
            priority: todo.priority,
            todoType: todo.todoType,
            contents: todo.contents
        )
        let todoBottomSheetViewController = TodoBottomSheetViewController(viewModel: viewModel)
        todoBottomSheetViewController.completionHandler = { [weak self] in
            self?.viewModel.fetchTodos()
        }
        present(todoBottomSheetViewController, animated: true)
    }
}

extension TodoListViewController: ODSSegmentedControlDelegate {
    
    func segmentedControl(_ segmentedControl: ODSSegmentedControl, to index: Int) {
        calendarView.setScope(index == 0 ? .week : .month, animated: true)
    }
}

extension TodoListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight = bounds.height
        calendarView.snp.updateConstraints {
            $0.height.equalTo(calendarHeight)
        }
        self.scrollView.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.currentDate.value = date
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        viewModel.currentDate.value = calendar.currentPage
        calendar.select(viewModel.currentDate.value)
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
