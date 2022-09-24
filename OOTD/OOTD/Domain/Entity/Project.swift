//
//  Project.swift
//  OOTD
//
//  Created by taekki on 2022/09/24.
//

import Foundation

struct Project {
    var id: String
    var name: String
    var desc: String
    var gitHubLink: String
    var member: [String]
    var startDate: Date
    var endDate: Date?
    var tech: [String]
    var memo: String?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        desc: String,
        gitHubLink: String,
        member: [String],
        startDate: Date,
        endDate: Date?,
        tech: [String],
        memo: String?
    ) {
        self.id = id
        self.name = name
        self.desc = desc
        self.gitHubLink = gitHubLink
        self.member = member
        self.startDate = startDate
        self.endDate = endDate
        self.tech = tech
        self.memo = memo
    }
}

extension Project: Entity {
    private var storableProject: StorableProject {
        let realmProject = StorableProject()
        realmProject.uuid = id
        realmProject.name = name
        realmProject.desc = desc
        realmProject.gitHubLink = gitHubLink
        realmProject.member.append(objectsIn: member)
        realmProject.startDate = startDate
        realmProject.endDate = endDate
        realmProject.tech.append(objectsIn: tech)
        realmProject.memo = memo
        return realmProject
    }
    
    func toStorable() -> StorableProject {
        return storableProject
    }
}
