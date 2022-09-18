//
//  PriorityCell.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

protocol PriorityCellDelegate: AnyObject {
    func priorityCell(_ cell: PriorityCell, index: Int)
}

final class PriorityCell: BaseCollectionViewCell {
    
    lazy var priorityButton = UIButton()
    
    private var priorities = ["p0", "p1", "p2", "p3", "p4", "없음"]
    var index: Int?
    var isChoosen: Bool = false {
        didSet { contentView.backgroundColor = isChoosen ? .yellow800 : .grey200 }
    }
    weak var delegate: PriorityCellDelegate?
    
    override func configureAttributes() {
        backgroundColor = .clear
        contentView.backgroundColor = .grey200
        makeRounded(radius: 20)
        
        priorityButton.do {
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .ootdFont(.bold, size: 14)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    override func configureLayout() {
        contentView.addSubview(priorityButton)
        priorityButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Spacing.s4)
        }
    }
}

extension PriorityCell {
    
    func configure(_ indexPath: IndexPath) {
        priorityButton.setTitle(priorities[indexPath.row], for: .normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.priorityCell(self, index: index ?? 0)
    }
}
