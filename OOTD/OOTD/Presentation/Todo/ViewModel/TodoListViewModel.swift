//
//  TodoListViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import Foundation

protocol TodoListViewModelProtocol {
    var todos: Observable<[Todo]> { get set }
    var currentDate: Observable<Date> { get set }
    var commitCount: Observable<Int> { get set }
    var todoPercent: Observable<Int> { get set }
    
    func fetchTodos()
}

final class TodoListViewModel: TodoListViewModelProtocol {
    
    private let repository: StorageRepository<Todo>?
    
    var todos: Observable<[Todo]> = Observable([])
    var currentDate: Observable<Date> = Observable(Date())
    var commitCount: Observable<Int> = Observable(0)
    var todoPercent: Observable<Int> = Observable(0)
    
    init(repository: StorageRepository<Todo>? = StorageRepository<Todo>()) {
        self.repository = repository
    }
    
    func fetchTodos() {
        guard let todos = repository?.fetchAll() else { return }
        self.todos.value = todos
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
