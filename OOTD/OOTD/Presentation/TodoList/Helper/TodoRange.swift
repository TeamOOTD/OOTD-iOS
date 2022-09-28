//
//  TodoRange.swift
//  OOTD
//
//  Created by taekki on 2022/09/28.
//

enum TodoRange {
    static let zero = 0..<1
    static let soso = 10..<30
    static let good = 30..<50
    static let nice = 50..<70
    static let great = 70..<90
    static let perpect = 90...
}

extension TodoRange {

    static func classify(todo: Int) -> Double {
        switch todo {
        case TodoRange.soso:
            return 0.2
        case TodoRange.good:
            return 0.4
        case TodoRange.nice:
            return 0.6
        case TodoRange.great:
            return 0.8
        case TodoRange.perpect:
            return 1.0
        default:
            return 0.0
        }
    }
}
