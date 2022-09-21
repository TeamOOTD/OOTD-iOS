//
//  Todo.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import Foundation

struct Todo {
    var id: String
    var isDone: Bool
    var todoType: Int
    var contents: String
    var priority: Int
    var time: Int?
    var projectID: Int?
    
    init(
        id: String = UUID().uuidString,
        isDone: Bool,
        todoType: Int,
        contents: String,
        priority: Int,
        time: Int? = nil,
        projectID: Int? = nil
    ) {
        self.id = id
        self.isDone = isDone
        self.todoType = todoType
        self.contents = contents
        self.priority = priority
        self.time = time
        self.projectID = projectID
    }
}

extension Todo: Entity {
    private var storableTodo: StorableTodo {
        let realmTodo = StorableTodo()
        realmTodo.uuid = id
        realmTodo.isDone = isDone
        realmTodo.todoType = todoType
        realmTodo.contents = contents
        realmTodo.priority = priority
        realmTodo.time = time
        realmTodo.projectID = projectID
        return realmTodo
    }
    
    func toStorable() -> StorableTodo {
        return storableTodo
    }
}
