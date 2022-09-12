//
//  ODSBasicBlockCell.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/13.
//



import UIKit

import SnapKit
import Then
import OOTD_Core

public final class ODSBasicBlockCell: BaseCollectionViewCell {
    
    private let contentLabel = UILabel()
    private let checkImageView = UIImageView()
    
    public enum BasicBlockType: String {
        case algorithm  = "알고리즘 문제 풀이"
        case commit     = "커밋"
        case blog       = "블로그 작성"
        case study      = "스터디"
        
        var color: UIColor? {
            switch self {
            case .algorithm: return .algorithm
            case .commit:    return .commit
            case .blog:      return .blog
            case .study:     return .study
            }
        }
    }
    
    public var blockType: BasicBlockType? {
        didSet {
            contentView.backgroundColor = blockType?.color
            contentLabel.text = blockType?.rawValue
        }
    }
    
    public override var isSelected: Bool {
        get { !checkImageView.isHidden }
        set { checkImageView.isHidden = !newValue }
    }
    
    public override func configureAttributes() {
        backgroundColor = .clear
        makeRounded(radius: Radii.r5)
        
        contentLabel.do {
            $0.textColor = .white
            $0.font = .ootdFont(.bold, size: 16)
            $0.textAlignment = .center
        }
        
        checkImageView.do {
            $0.image = .icnCheck?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
            $0.isHidden = true
        }
    }
    
    public override func configureLayout() {
        contentView.addSubviews(contentLabel, checkImageView)
        
        contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Spacing.s8)
            $0.leading.trailing.equalToSuperview().inset(Spacing.s4)
        }
        
        checkImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(Spacing.s8)
        }
    }
}
