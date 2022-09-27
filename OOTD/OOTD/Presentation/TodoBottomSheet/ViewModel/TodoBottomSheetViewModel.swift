//
//  TodoBottomSheetViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import UIKit

import OOTD_UIKit

protocol TodoBottomSheetViewModel {
    var state: ObservableHelper<TodoBottomSheetState> { get set }
    var section: ObservableHelper<[TodoBottomSheetSection]> { get set }
    var item: ObservableHelper<Todo> { get set }
    var priority: ObservableHelper<Int> { get set }
    var todoType: ObservableHelper<Int> { get set }
    var contents: ObservableHelper<String> { get set }
    var projectID: ObservableHelper<String> { get set }
    
    func inputSection(isHidden: Bool)
    func createTodo(completion: (() -> Void)?)
    func deleteTodo(completion: (() -> Void)?)
    func updateTodo(completion: (() -> Void)?)
}

final class TodoBottomSheetViewModelImpl: TodoBottomSheetViewModel {
    
    private let todoRepository: StorageRepository<Todo>
    private let projectRepository: StorageRepository<Project>
    
    var state: ObservableHelper<TodoBottomSheetState> = ObservableHelper(.create)
    var section: ObservableHelper<[TodoBottomSheetSection]> = ObservableHelper([.priority, .todo, .project])
    var item: ObservableHelper<Todo> = ObservableHelper(Todo(isDone: false, todoType: 0, contents: "", priority: 0))
    var priority: ObservableHelper<Int> = ObservableHelper(0)
    var todoType: ObservableHelper<Int> = ObservableHelper(0)
    var contents: ObservableHelper<String> = ObservableHelper("")
    var projectID = ObservableHelper<String>("")
    
    init(
        todoRepository: StorageRepository<Todo> = StorageRepository<Todo>(),
        projectRepository: StorageRepository<Project> = StorageRepository<Project>(),
        state: TodoBottomSheetState = .create,
        item: Todo = Todo(isDone: false, todoType: 0, contents: "", priority: 0),
        priority: Int = 0,
        todoType: Int = 0,
        contents: String = "",
        projectID: String = ""
    ) {
        let isHidden = todoType == 0 || todoType == 1 || todoType == 2
        
        self.todoRepository = todoRepository
        self.projectRepository = projectRepository
        self.section.value = isHidden ? [.priority, .todo, .project] : [.priority, .todo, .input, .project]
        self.state.value = state
        self.item.value = item
        self.priority.value = priority
        self.todoType.value = todoType
        self.contents.value = contents
        self.projectID.value = projectID
    }
    
    func inputSection(isHidden: Bool) {
        section.value = isHidden ? [.priority, .todo, .project] : [.priority, .todo, .input, .project]
    }

    func createTodo(completion: (() -> Void)? = nil) {
        do {
            if todoType.value == 0 || todoType.value == 1 || todoType.value == 2 {
                contents.value = block[todoType.value].rawValue
            }
            let todo = Todo(isDone: false, todoType: todoType.value, contents: contents.value, priority: priority.value, projectID: projectID.value)
            try todoRepository.create(item: todo)
            completion?()
        } catch {
            print(error)
        }
    }
    
    func deleteTodo(completion: (() -> Void)? = nil) {
        do {
            try todoRepository.delete(item: item.value)
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
            item.value.projectID = projectID.value
            try todoRepository.update(item: item.value)
            completion?()
        } catch {
            print(error)
        }
    }
}

extension TodoBottomSheetViewModelImpl: TodoBottomSheetCollectionViewAdapterDataSource {
    
    var todo: Todo {
        return Todo(isDone: false, todoType: todoType.value, contents: contents.value, priority: priority.value, projectID: projectID.value)
    }
    
    var block: [ODSBasicBlockCell.BasicBlockType] {
        return [.algorithm, .blog, .commit, .study, .direct]
    }
    
    var projects: [(String, UIImage?)] {
        projectRepository.fetchAll().map {
            return ($0.id, try! projectRepository.fetchImage(filename: "\($0.id).jpeg"))
        }
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
        case .project:   return projects.count + 1
        }
    }
}
