//
//  ProjectArchiveViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import Foundation

import OOTD_UIKit
import RxSwift
import RxCocoa

final class ProjectArchiveViewModel {
    let itemViewModel = BehaviorRelay(value: [])
    
    var name = BehaviorRelay(value: "")
    var desc = BehaviorRelay(value: "")
    var link = BehaviorRelay(value: "")
    var member = BehaviorRelay(value: [String]())
    var startDate = BehaviorRelay<Date?>(value: nil)
    var endDate = BehaviorRelay<Date?>(value: nil)
    var tech = BehaviorRelay(value: [String]())
    var memo = BehaviorRelay<String?>(value: nil)

    var isValid: Observable<Bool> {
        return Observable.combineLatest(name, desc, startDate, tech).map { name, desc, startDate, tech in
            return name.isNotEmpty && desc.isNotEmpty && startDate != nil && tech.isNotEmpty
        }
    }
    
    var project: Project = .init(name: "", desc: "", gitHubLink: "", member: [], startDate: Date(), endDate: nil, tech: [], memo: nil)
    
    // MARK: - Private Properties
    private let projectRepository: StorageRepository<Project>
    private let disposeBag = DisposeBag()

    init(projectRepository: StorageRepository<Project>) {
        self.projectRepository = projectRepository
    }

    func saveProject() {
        project.name = name.value
        project.desc = desc.value
        project.gitHubLink = link.value
        project.member = member.value
        project.startDate = startDate.value ?? Date()
        project.endDate = endDate.value
        project.tech = tech.value
        project.memo = memo.value
        
        do {
            try projectRepository.update(item: project)
        } catch {
            print(error)
        }
    }
}

extension ProjectArchiveViewModel: ProjectArchiveCollectionViewAdapterDataSource {
    
    var sections: [ProjectArchiveSection] {
        return ProjectArchiveSection.allCases
    }
    
    var numberOfSections: Int {
        return ProjectArchiveSection.allCases.count
    }
    
    var numberOfItems: Int {
        return 1
    }
    
    func numberOfItems(section: Int) -> Int {
        return 1
    }
    
    func fetchSection(section: Int) -> ProjectArchiveSection {
        return sections[section]
    }
}
