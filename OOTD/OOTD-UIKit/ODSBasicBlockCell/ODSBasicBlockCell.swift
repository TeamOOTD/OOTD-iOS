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

public protocol ODSBasicBlockCellDelegate: AnyObject {
    func basicBlockCell(_ cell: ODSBasicBlockCell, index: Int)
}

public final class ODSBasicBlockCell: BaseCollectionViewCell {
    
    private lazy var contentButton = UIButton()
    private let checkImageView = UIImageView()
    
    public weak var delegate: ODSBasicBlockCellDelegate?
    
    public enum BasicBlockType: String {
        case algorithm  = "알고리즘 문제 풀이"
        case commit     = "커밋"
        case blog       = "블로그 작성"
        case study      = "스터디"
        case direct     = "직접 입력"
        
        var color: UIColor? {
            switch self {
            case .algorithm: return .algorithm
            case .commit:    return .commit
            case .blog:      return .blog
            case .study:     return .study
            case .direct:    return .grey700
            }
        }
    }
    
    public var blockType: BasicBlockType? {
        didSet {
            contentView.backgroundColor = blockType?.color
            contentButton.setTitle(blockType?.rawValue, for: .normal)
        }
    }
    
    public var index: Int?
    public var isChoosen: Bool = false {
        didSet { checkImageView.isHidden = !isChoosen }
    }

    public override func configureAttributes() {
        backgroundColor = .clear
        makeRounded(radius: Radii.r5)
        
        contentButton.do {
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .ootdFont(.bold, size: 16)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        checkImageView.do {
            $0.image = .icnCheck?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
            $0.isHidden = true
        }
    }
    
    public override func configureLayout() {
        contentView.addSubviews(contentButton, checkImageView)
        
        contentButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Spacing.s8)
            $0.leading.trailing.equalToSuperview().inset(Spacing.s4)
        }
        
        checkImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(Spacing.s8)
        }
    }
}

extension ODSBasicBlockCell {
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.basicBlockCell(self, index: index ?? 0)
    }
}
