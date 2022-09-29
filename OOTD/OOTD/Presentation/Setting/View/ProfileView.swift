//
//  ProfileView.swift
//  OOTD
//
//  Created by taekki on 2022/09/29.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProfileView: BaseView {
    
    private let usernameLabel = UILabel()
    private lazy var hStackView = UIStackView(
        arrangedSubviews: [commitView, commitCountLabel, todoView, todoCountLabel]
    )
    private let commitView = UIView()
    private let commitCountLabel = UILabel()
    private let todoView = UIView()
    private let todoCountLabel = UILabel()
    
    var commit = 0 {
        didSet {
            commitCountLabel.text = "오늘 커밋 \(String(describing: commit))개"
        }
    }
    
    var todoCount = 0 {
        didSet {
            todoCountLabel.text = "오늘 할 일 \(todoCount)개"
        }
    }

    override func configureAttributes() {
        backgroundColor = .white
        makeRounded(radius: 12)
        layer.borderColor = UIColor.grey900.cgColor
        layer.borderWidth = 1

        if let commit = UserDefaults.standard.object(forKey: "todayCommit") as? Int {
            self.commit = commit
        }
        
        usernameLabel.do {
            if let nickname = UserDefaults.standard.string(forKey: "gitHubAccount") {
                $0.text = "\(nickname)님"
                $0.textColor = .grey800
                $0.font = .ootdFont(.bold, size: 24)
            } else {
                $0.text = "Taehyeon-Kim님"
                $0.textColor = .grey800
                $0.font = .ootdFont(.bold, size: 24)
            }
        }
        
        hStackView.do {
            $0.spacing = 6
            $0.setCustomSpacing(30, after: commitCountLabel)
        }
        
        commitView.do {
            $0.backgroundColor = .green800
        }
        
        commitCountLabel.do {
            $0.text = "오늘 커밋 \(commit)개"
            $0.textColor = .grey800
            $0.font = .ootdFont(.bold, size: 14)
        }
        
        todoView.do {
            $0.backgroundColor = .yellow800
        }
        
        todoCountLabel.do {
            $0.textColor = .grey800
            $0.font = .ootdFont(.bold, size: 14)
        }
    }
    
    override func configureLayout() {
        addSubviews(usernameLabel, hStackView)

        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        commitView.snp.makeConstraints {
            $0.size.equalTo(18)
        }

        todoView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
}
