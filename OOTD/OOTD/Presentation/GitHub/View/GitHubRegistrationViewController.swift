//
//  GitHubRegistrationViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/12.
//

import UIKit

import FSCalendar
import OOTD_Core
import OOTD_UIKit

final class GitHubRegistrationViewController: BaseViewController {
    
    private let messageLabel = UILabel()
    private let gitHubNicknameTextField = ODSTextField()
    private lazy var buttonVStackView = UIStackView(arrangedSubviews: [confirmButton, registrationButton])
    private lazy var confirmButton = ODSButton(.enabled)
    private lazy var registrationButton = ODSButton(.sub)
    
    private let manager = GitHubManager(apiService: APIManager(), environment: .development)
    
    override func configureAttributes() {
        view.backgroundColor = .white
        
        messageLabel.do {
            $0.text = """
            커밋 기록을 확인하기 위해
            GitHub 닉네임을 등록해보세요.
            """
            $0.textColor = .grey900
            $0.textAlignment = .center
            $0.font = .ootdFont(.bold, size: 24)
            $0.numberOfLines = 0
        }
        
        gitHubNicknameTextField.do {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.placeholder = "본인의 GitHub 계정을 정확하게 입력해주세요."
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
        
        registrationButton.do {
            $0.title = "다음에 등록하기"
            $0.button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        view.addSubviews(messageLabel, gitHubNicknameTextField, buttonVStackView)
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        gitHubNicknameTextField.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(30)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Spacing.s20)
            $0.height.equalTo(40)
        }
        
        buttonVStackView.snp.makeConstraints {
            $0.top.equalTo(gitHubNicknameTextField.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Spacing.s20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        registrationButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}

extension GitHubRegistrationViewController {
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        guard let username = gitHubNicknameTextField.text else { return }
        fetchUser(for: username)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        self.presentAlert(title: "다음에 등록하실래요?", isIncludedCancel: true, okActionTitle: "네", cancelActionTitle: "아니오", okCompletion: { [weak self] _ in
            UserDefaults.standard.set(false, forKey: "isFirstLogin")
            self?.changeRootToTabBarController()
        })
    }
    
    private func fetchUser(for username: String) {
        Task {
            let response = try await manager.fetchUser(for: username)
            
            if let login = response?.login {
                UserDefaults.standard.set(login, forKey: "gitHubAccount")
                self.presentAlert(title: "\(login)님이 맞으신가요?", isIncludedCancel: true, okActionTitle: "네", cancelActionTitle: "아니오", okCompletion: { [weak self] _ in
                    UserDefaults.standard.set(false, forKey: "isFirstLogin")
                    self?.changeRootToTabBarController()
                })
            } else {
                self.presentAlert(title: "없는 계정입니다.")
            }
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
