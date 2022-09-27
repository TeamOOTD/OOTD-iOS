//
//  SceneDelegate.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            let rootViewController: UIViewController!
            
            if UserDefaults.standard.object(forKey: "isFirstLogin") == nil {
                rootViewController = GitHubRegistrationViewController()
            } else {
                rootViewController = TabBarController()
            }
            
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            self?.window?.layer.add(transition, forKey: kCATransition)
            self?.window?.rootViewController = rootViewController
        }
        
        window?.makeKeyAndVisible()
    }
}
