//
//  ProjectArchiveViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import Foundation

import OOTD_UIKit

final class ProjectArchiveViewModel {

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
