//
//  ProjectListCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectListCell: BaseCollectionViewCell {
    
    private let logoImageView = UIImageView()
    private let projectNameLabel = UILabel()
    private let projectDescriptionLabel = UILabel()
    private lazy var tagHStackView = UIStackView()
    private let countLabel = UILabel()
    private let periodLabel = UILabel()
    private let statusLabel = ODSTagView()
    
    override func configureAttributes() {
        backgroundColor = .clear
        contentView.makeRounded(radius: Radii.r5)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.grey300.cgColor
        
        logoImageView.do {
            $0.image = .icnCamera
            $0.makeRounded(radius: Radii.r4)
        }
        
        projectNameLabel.do {
            $0.text = "OOTD"
            $0.textColor = .grey900
            $0.font = .ootdFont(.bold, size: 14)
        }
        
        projectDescriptionLabel.do {
            $0.text = "새싹 개인 프로젝트, OOTD"
            $0.textColor = .grey800
            $0.font = .ootdFont(.regular, size: 10)
        }
        
        tagHStackView.do {
            $0.distribution = .fillProportionally
            $0.spacing = 4
        }
        
        countLabel.do {
            $0.isHidden = true
            $0.textColor = .grey800
            $0.font = .ootdFont(.regular, size: 10)
        }
        
        periodLabel.do {
            $0.text = "2022.01 -> 2022.07"
            $0.textColor = .grey600
            $0.font = .ootdFont(.regular, size: 10)
        }
        
        statusLabel.do {
            $0.content = "진행 중"
            $0.backgroundColor = .yellow800
        }
    }
    
    override func configureLayout() {
        contentView.addSubviews(logoImageView, projectNameLabel, projectDescriptionLabel, tagHStackView, countLabel, periodLabel, statusLabel)
        
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(64)
            $0.leading.equalToSuperview().inset(Spacing.s16)
            $0.centerY.equalToSuperview()
        }
        
        projectNameLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(Spacing.s16)
            $0.top.equalTo(logoImageView.snp.top).inset(Spacing.s4)
        }
        
        projectDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(Spacing.s16)
            $0.top.equalTo(projectNameLabel.snp.bottom)
        }
        
        tagHStackView.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(Spacing.s16)
            $0.top.equalTo(projectDescriptionLabel.snp.bottom).offset(2)
            $0.trailing.lessThanOrEqualToSuperview().inset(40)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(tagHStackView)
            $0.leading.equalTo(tagHStackView.snp.trailing).offset(4)
        }
        
        periodLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(Spacing.s16)
            $0.top.equalTo(tagHStackView.snp.bottom).offset(2)
        }
        
        statusLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Spacing.s16)
            $0.centerY.equalTo(projectNameLabel.snp.centerY)
        }
    }
}

extension ProjectListCell {
    
    func createTagView(with tags: [String]) {
        tagHStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for (index, tag) in tags.enumerated() where index < 4 {
            let tagView = ODSTagView()
            tagView.content = tag
            tagView.backgroundColor = .grey700
            tagHStackView.addArrangedSubview(tagView)
        }
        
        if tags.count > 4 {
            countLabel.isHidden = false
            countLabel.text = "+\(tags.count - 4)"
        }
    }
    
    func configure(with project: Project, image: UIImage?) {
        logoImageView.image = image
        projectNameLabel.text = project.name
        projectDescriptionLabel.text = project.desc
        periodLabel.text = project.term
        statusLabel.do {
            $0.content = project.isInProgress ? "진행 중" : "진행 완료"
            $0.backgroundColor = project.isInProgress ? .yellow800 : .green800
        }
    }
}
