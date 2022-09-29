//
//  TokenViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/29.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class TokenViewController: BaseViewController {
    
    private let navigationBar = ODSNavigationBar()
    private let textField = ODSTextField()
    private lazy var buttonVStackView = UIStackView(arrangedSubviews: [confirmButton])
    private lazy var confirmButton = ODSButton(.enabled)

    private let manager = GitHubManager(apiService: APIManager(), environment: .development)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureAttributes() {
        view.backgroundColor = .white
        
        navigationBar.do {
            $0.leftBarItem = .back
            $0.title = "토근 등록하기"
            $0.leftButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        }

        textField.do {
            $0.font = UIFont.systemFont(ofSize: 14)
            if let token = UserDefaults.standard.string(forKey: "accessToken") {
                $0.text = token
            } else {
                $0.placeholder = "Personal Token을 입력해주세요."
            }
            $0.autocorrectionType = .no
        }
        
        buttonVStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = Spacing.s4
        }
        
        confirmButton.do {
            $0.title = "완료"
            $0.button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        }

    }
    
    override func configureLayout() {
        view.addSubviews(navigationBar, textField, buttonVStackView)
        
        navigationBar.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Spacing.s20)
            $0.height.equalTo(44)
        }
        
        buttonVStackView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Spacing.s20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}

extension TokenViewController {
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        guard let token = textField.text else { return }
        presentAlert(title: "\(token)이 맞나요?") { [weak self] _ in
            UserDefaults.standard.set("Bearer \(token)", forKey: "accessToken")
            self?.changeRootToTabBarController()
        }
    }
    
    private func changeRootToTabBarController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let tabBarController = TabBarController()
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        sceneDelegate?.window?.rootViewController = tabBarController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
