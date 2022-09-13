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
        case .todo:     return UIImage.icnTabCheckList?.withTintColor(.grey400, renderingMode: .alwaysTemplate)
        case .project:  return UIImage.icnTabProjectList.withTintColor(.grey400, renderingMode: .alwaysTemplate)
        case .profile:  return UIImage.icnTabProfile.withTintColor(.grey400, renderingMode: .alwaysTemplate)
        }
    }
    
    var activeIcon: UIImage? {
        switch self {
        case .todo:     return UIImage.icnTabCheckList?.withTintColor(.grey900, renderingMode: .alwaysTemplate)
        case .project:  return UIImage.icnTabProjectList.withTintColor(.grey900, renderingMode: .alwaysTemplate)
        case .profile:  return UIImage.icnTabProfile.withTintColor(.grey900, renderingMode: .alwaysTemplate)
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
