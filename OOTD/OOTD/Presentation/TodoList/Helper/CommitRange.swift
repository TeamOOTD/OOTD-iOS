//
//  CommitRange.swift
//  OOTD
//
//  Created by taekki on 2022/09/28.
//

enum CommitRange {
    static let zero = 0..<1
    static let soso = 0..<5
    static let good = 5..<10
    static let nice = 10..<15
    static let great = 15..<20
    static let perpect = 20...
}

extension CommitRange {

    static func classify(commit: Int) -> Double {
        switch commit {
        case CommitRange.soso:
            return 0.2
        case CommitRange.good:
            return 0.4
        case CommitRange.nice:
            return 0.6
        case CommitRange.great:
            return 0.8
        case CommitRange.perpect:
            return 1.0
        default:
            return 0.0
        }
    }
}
