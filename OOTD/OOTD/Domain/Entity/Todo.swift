//
//  Todo.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

struct Todo {
    var isDone: Bool
    var todoType: Int
    var contents: String
    var priority: Int
    var time: Int?
    var projectID: Int?
}

extension Todo: Entity {
    private var storableTodo: StorableTodo {
        let realmTodo = StorableTodo()
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
