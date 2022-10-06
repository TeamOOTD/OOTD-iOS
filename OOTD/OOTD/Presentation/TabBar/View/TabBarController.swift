//
//  TabBarController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class TabBarController: UITabBarController {
    
    private let tabBarItems = TabBarItem.allCases
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureTabBar()
        configureTabBarAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBar() {
        setViewControllers(createTabBarViewController(self.tabBarItems), animated: true)
    }
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = .grey900
        tabBar.unselectedItemTintColor = .grey400

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension TabBarController {
    
    private func createTabBarViewController(_ tabBarItems: [TabBarItem]) -> [UIViewController] {
        
        return tabBarItems.map { tabBarItem in
            let viewController: UIViewController
            
            switch tabBarItem {
            case .todo:
                viewController = UINavigationController(rootViewController: TodoListViewController())
            
            case .project:
                let projectViewModel = ProjectListViewModelImpl(
                    projectRepository: StorageRepository<Project>()
                )
                let projectViewController = ProjectViewController(viewModel: projectViewModel)
                viewController = UINavigationController(rootViewController: projectViewController)
                
            case .profile:
                viewController = UINavigationController(rootViewController: SettingViewController(reactor: SettingViewReactor()))
            }
            
            viewController.tabBarItem = tabBarItem.asTabBarItem()
            return viewController
        }
    }
}
