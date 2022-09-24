//
//  TodoBottomSheetViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import Foundation

import OOTD_UIKit

protocol TodoBottomSheetViewModelProtocol {
    var state: ObservableHelper<TodoBottomSheetState> { get set }
    var section: ObservableHelper<[TodoBottomSheetSection]> { get set }
    var item: ObservableHelper<Todo> { get set }
    var priority: ObservableHelper<Int> { get set }
    var todoType: ObservableHelper<Int> { get set }
    var contents: ObservableHelper<String> { get set }
    
    func inputSection(isHidden: Bool)
    func createTodo(completion: (() -> Void)?)
    func deleteTodo(completion: (() -> Void)?)
    func updateTodo(completion: (() -> Void)?)
}

final class TodoBottomSheetViewModel: TodoBottomSheetViewModelProtocol {
    
    private let repository: StorageRepository<Todo>?
    
    var state: ObservableHelper<TodoBottomSheetState> = ObservableHelper(.create)
    var section: ObservableHelper<[TodoBottomSheetSection]> = ObservableHelper([.priority, .todo, .project])
    var item: ObservableHelper<Todo> = ObservableHelper(Todo(isDone: false, todoType: 0, contents: "", priority: 0))
    var priority: ObservableHelper<Int> = ObservableHelper(0)
    var todoType: ObservableHelper<Int> = ObservableHelper(0)
    var contents: ObservableHelper<String> = ObservableHelper("")
    
    init(
        repository: StorageRepository<Todo>? = StorageRepository<Todo>(),
        state: TodoBottomSheetState = .create,
        item: Todo = Todo(isDone: false, todoType: 0, contents: "", priority: 0),
        priority: Int = 0,
        todoType: Int = 0,
        contents: String = ""
    ) {
        let isHidden = todoType == 0 || todoType == 1 || todoType == 2
        
        self.repository = repository
        self.section.value = isHidden ? [.priority, .todo, .project] : [.priority, .todo, .input, .project]
        self.state.value = state
        self.item.value = item
        self.priority.value = priority
        self.todoType.value = todoType
        self.contents.value = contents
    }
    
    func inputSection(isHidden: Bool) {
        section.value = isHidden ? [.priority, .todo, .project] : [.priority, .todo, .input, .project]
    }

    func createTodo(completion: (() -> Void)? = nil) {
        do {
            if todoType.value == 0 || todoType.value == 1 || todoType.value == 2 {
                contents.value = block[todoType.value].rawValue
            }
            let todo = Todo(isDone: false, todoType: todoType.value, contents: contents.value, priority: priority.value)
            try repository?.create(item: todo)
            completion?()
        } catch {
            print(error)
        }
    }
    
    func deleteTodo(completion: (() -> Void)? = nil) {
        do {
            try repository?.delete(item: item.value)
            completion?()
        } catch {
            print(error)
        }
    }
    
    func updateTodo(completion: (() -> Void)? = nil) {
        do {
            if todoType.value == 0 || todoType.value == 1 || todoType.value == 2 {
                contents.value = block[todoType.value].rawValue
            }
            item.value.priority = priority.value
            item.value.todoType = todoType.value
            item.value.contents = contents.value
            try repository?.update(item: item.value)
            completion?()
        } catch {
            print(error)
        }
    }
}

extension TodoBottomSheetViewModel: TodoBottomSheetCollectionViewAdapterDataSource {

    var todo: Todo {
        return Todo(isDone: false, todoType: todoType.value, contents: contents.value, priority: priority.value, projectID: 0)
    }
    
    var block: [ODSBasicBlockCell.BasicBlockType] {
        return [.algorithm, .blog, .commit, .study, .direct]
    }
    
    var numberOfSections: Int {
        return section.value.count
    }
    
    func fetchSection(section: Int) -> TodoBottomSheetSection {
        return self.section.value[section]
    }
    
    func numberOfItems(section: Int) -> Int {
        switch self.section.value[section] {
        case .priority:  return Priority.allCases.count
        case .todo:      return 5
        case .input:     return 1
        case .project:   return 1
        }
    }
}
