//
//  StorableTodo.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import RealmSwift

final class StorableTodo: Object, Storable {
    
    @Persisted var uuid: String
    @Persisted var isDone: Bool = false
    @Persisted var todoType: Int
    @Persisted var contents: String
    @Persisted var priority: Int
    @Persisted var time: Int?
    @Persisted var projectID: Int?
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    var model: Todo {
        return Todo(
            id: uuid,
            isDone: isDone,
            todoType: todoType,
            contents: contents,
            priority: priority,
            time: time,
            projectID: projectID
        )
    }
}
