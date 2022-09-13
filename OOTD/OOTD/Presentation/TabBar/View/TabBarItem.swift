//
//  TabBarItem.swift
//  OOTD
//
//  Created by taekki on 2022/09/13.
//

import UIKit

import OOTD_UIKit

enum TabBarItem: Int, CaseIterable {
    case todo
    case project
    case profile
}

extension TabBarItem {
    var title: String? {
        switch self {
        case .todo:     return "투두"
        case .project:  return "프로젝트"
        case .profile:  return "프로필"
        }
    }
    
    var inactiveIcon: UIImage? {
        switch self {
        case .todo:     return UIImage.icnTabCheckList
        case .project:  return UIImage.icnTabProjectList
        case .profile:  return UIImage.icnTabProfile
        }
    }
    
    var activeIcon: UIImage? {
        switch self {
        case .todo:     return UIImage.icnTabCheckList
        case .project:  return UIImage.icnTabProjectList
        case .profile:  return UIImage.icnTabProfile
        }
    }
}

extension TabBarItem {
    func asTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: title,
            image: inactiveIcon,
            selectedImage: activeIcon
        )
    }
}
