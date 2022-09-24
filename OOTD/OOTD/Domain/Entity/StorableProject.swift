//
//  StorableProject.swift
//  OOTD
//
//  Created by taekki on 2022/09/24.
//

import Foundation

import RealmSwift

final class StorableProject: Object, Storable {
    
    @Persisted var uuid: String
    @Persisted var name: String
    @Persisted var desc: String
    @Persisted var gitHubLink: String
    @Persisted var member: List<String>
    @Persisted var startDate: Date
    @Persisted var endDate: Date?
    @Persisted var tech: List<String>
    @Persisted var memo: String?
    @Persisted var createdAt: Date? = Date()
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    var model: Project {
        return Project(
            name: name,
            desc: desc,
            gitHubLink: gitHubLink,
            member: member.map{$0},
            startDate: startDate,
            endDate: endDate,
            tech: tech.map{$0},
            memo: memo
        )
    }
}
