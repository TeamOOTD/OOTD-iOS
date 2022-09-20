//
//  TodoBottomSheetViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import Foundation

import OOTD_UIKit

protocol TodoBottomSheetViewModelProtocol {
    var section: Observable<[TodoBottomSheetSection]> { get set }
    
    func inputSection(isHidden: Bool)
    func createTodo(completion: (() -> Void)?)
}

final class TodoBottomSheetViewModel: TodoBottomSheetViewModelProtocol {
    
    private let repository: StorageRepository<Todo>?
    
    var section: Observable<[TodoBottomSheetSection]> = Observable([.priority, .todo, .project])

    var priority = Observable(0)
    var todoType = Observable(0)
    var contents = Observable("")
    
    init(repository: StorageRepository<Todo>? = StorageRepository<Todo>()) {
        self.repository = repository
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
        case .priority:  return 6
        case .todo:      return 5
        case .input:     return 1
        case .project:   return 1
        }
    }
}
