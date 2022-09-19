//
//  StorableTodo.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import RealmSwift

final class StorableTodo: Object, Storable {
    
    @Persisted var isDone: Bool = false
    @Persisted var todoType: Int
    @Persisted var contents: String
    @Persisted var priority: Int
    @Persisted var time: Int?
    @Persisted var projectID: Int?
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    var model: Todo {
        return Todo(
            isDone: isDone,
            todoType: todoType,
            contents: contents,
            priority: priority,
            time: time,
            projectID: projectID
        )
    }
}
