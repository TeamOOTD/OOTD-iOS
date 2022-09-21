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
    
    // MARK: - Properties
    
    private let viewModel = TodoListViewModel()
    private lazy var adapter: TodoListCollectionViewAdapter = {
        let adapter = TodoListCollectionViewAdapter(collectionView: collectionView, adapterDataSource: viewModel, delegate: self)
        return adapter
    }()
    
    // MARK: - UI Properties
    
    private let navigationBar = ODSNavigationBar()
    private let headerView = TodoCalendarHeaderView()
    private let scrollView = UIScrollView()
    private let containerStackView = UIStackView()
    private let calendarView = FSCalendar()
    private let collectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private let dateFormatter = DateFormatter()
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchTodos()
    }
    
    // MARK: - Override Functions

    override func configureAttributes() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        configureCalendarView()
        
        dateFormatter.do {
            $0.dateFormat = "YYYY년 M월 d일"
            $0.locale = Locale(identifier: "ko_KR")
            $0.timeZone = TimeZone(identifier: "ko_KR")
        }
        
        navigationBar.do {
            $0.rightBarItem = .timer
        }
        
        headerView.do {
            $0.date = dateFormatter.string(from: viewModel.currentDate.value)
            $0.commitCount = viewModel.commitCount.value
            $0.todoPercent = viewModel.todoPercent.value
        }
        
        containerStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = Spacing.s16
        }
    }
    
    override func configureLayout() {
        view.addSubviews(navigationBar, headerView, scrollView)
        scrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubviews(calendarView, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(Spacing.s8)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(70.adjustedHeight)
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
            $0.leading.trailing.equalToSuperview().inset(Spacing.s24)
        }
    }
}

extension TodoListViewController {
    
    private func bind() {
        adapter.adapterDataSource = viewModel
        viewModel.fetchTodos()
        
        viewModel.todos.bind { [weak self] todos in
            // reload를 그냥 여기서 해주면 되는 문제였음.
            self?.collectionView.reloadData()
            self?.headerView.todoPercent = todos.count
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

extension TodoListViewController: TodoListCollectionViewAdapterDelegate {
    func todoHeaderViewCreateButtonDidTap() {
        presentBottomSheetViewController()
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

extension TodoListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

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
