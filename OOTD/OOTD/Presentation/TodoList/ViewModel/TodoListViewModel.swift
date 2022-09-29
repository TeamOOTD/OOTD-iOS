//
//  TodoListViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import Foundation

protocol TodoListViewModelProtocol {
    var todos: ObservableHelper<[Todo]> { get set }
    var currentDate: ObservableHelper<Date> { get set }
    var commitCount: ObservableHelper<Int> { get set }
    var todoPercent: ObservableHelper<Int> { get set }

    func calculateTodoPercent()
    func fetchTodos()
    func updateTodo(item: Todo, completion: (() -> Void)?)
    func fetchTodayCommit()
}

final class TodoListViewModel: TodoListViewModelProtocol {
    
    private let repository: StorageRepository<Todo>?
    private let manager: GitHubManager
    
    var today: Date {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var dateComponents = DateComponents()
        dateComponents.year = date.year
        dateComponents.month = date.month
        dateComponents.day = date.day
        guard let today = Calendar.current.date(from: dateComponents) else { return Date() }
        return today
    }
    var todos: ObservableHelper<[Todo]> = ObservableHelper([])
    var currentDate: ObservableHelper<Date> = ObservableHelper(Date())
    var commitCount = ObservableHelper(0)
    var todoPercent = ObservableHelper(0)
    
    lazy var dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.sss'Z'"
    }
    
    init(
        repository: StorageRepository<Todo>? = StorageRepository<Todo>(),
        manager: GitHubManager
    ) {
        self.repository = repository
        self.manager = manager
        
        currentDate.value = today
        fetchTodayCommit()
    }
    
    func calculateTodoPercent() {
        self.todoPercent.value = calculateTodoPercent(for: todos.value)
    }
    
    func calculateTodoPercent(for todos: [Todo]) -> Int {
        let todoPercent = todos.isEmpty ? 0 : Double(todos.filter { $0.isDone == true }.count) / Double(todos.count) * 100.0
        return Int(todoPercent)
    }
    
    func fetchTodos() {
        self.todos.value = fetchTodo(for: currentDate.value)
    }
    
    func fetchTodo(for date: Date) -> [Todo] {
        let currentDateString = dateFormatter.string(from: date)
        guard let currentDate = dateFormatter.date(from: currentDateString) else { return [] }
        guard let todos = repository?.fetchByDate(by: currentDate, keyPath: "priority") else { return [] }
        return todos
    }
    
    func updateTodo(item: Todo, completion: (() -> Void)? = nil) {
        do {
            try repository?.update(item: item)
            completion?()
        } catch {
            print(error)
        }
    }
    
    func fetchTodayCommit() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        guard let username = UserDefaults.standard.string(forKey: "gitHubAccount") else { return }

        Task {
            let response = try await manager.fetchEvents(for: username)
            if let repos = response {
                let events = repos.filter {
                    return (dateFormatter.string(from: currentDate.value).prefix(10) == $0.createdAt?.prefix(10))
                }.filter {
                    return $0.type == "PushEvent" || $0.type == "PullRequestEvent" || $0.type == "CreateEvent" || $0.type == "IssuesEvent"
                }
                commitCount.value = events.count
            }
        }
    }
}

extension TodoListViewModel: TodoListCollectionViewAdapterDataSource {
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfItems: Int {
        return todos.value.count
    }
    
    func todo(at index: Int) -> Todo {
        return todos.value[index]
    }
}
