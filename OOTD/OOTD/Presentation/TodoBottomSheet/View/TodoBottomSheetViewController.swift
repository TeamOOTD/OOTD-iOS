//
//  TodoBottomSheetViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/16.
//

import UIKit

import SnapKit
import Then
import OOTD_Core
import OOTD_UIKit

final class TodoBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel = TodoBottomSheetViewModel()
    private lazy var adapter: TodoBottomSheetCollectionViewAdapter = {
        let adapter = TodoBottomSheetCollectionViewAdapter(collectionView: collectionView, adapterDataSource: viewModel, delegate: self)
        return adapter
    }()
    var completionHandler: (() -> Void)?
    
    // MARK: - UI Properties

    private lazy var collectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private lazy var doneButton = ODSButton(.enabled)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    override func configureAttributes() {
        view.backgroundColor = .systemBackground

        doneButton.do {
            $0.title = "확인"
            $0.actionHandler = { [weak self] in
                self?.viewModel.createTodo {
                    self?.dismiss(animated: true)
                    self?.completionHandler?()
                }
            }
        }
        
        setupSheet()
    }
    
    override func configureLayout() {
        view.addSubviews(collectionView, doneButton)

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Spacing.s32)
            $0.leading.bottom.trailing.equalToSuperview().inset(Spacing.s24)
        }
        
        doneButton.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview().inset(Spacing.s24)
            $0.height.equalTo(50)
        }
    }
    
    private func bind() {
        adapter.adapterDataSource = viewModel
        
        viewModel.section.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.priority.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.todoType.bind { [weak self] type in
            if type == 3 || type == 4 {
                self?.viewModel.inputSection(isHidden: false)
            } else {
                self?.viewModel.inputSection(isHidden: true)
            }
            
            self?.collectionView.reloadData()
        }
    }
}

extension TodoBottomSheetViewController {
    
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = Radii.r20
        }
    }
}

extension TodoBottomSheetViewController: TodoBottomSheetCollectionViewAdapterDelegate {
    
    func priorityCellTapped(at index: Int) {
        viewModel.priority.value = index
    }
    
    func todoBlockCellTapped(at index: Int) {
        viewModel.todoType.value = index
    }
    
    func inputTextFieldValueChanged(text: String?) {
        guard let text else { return }
        viewModel.contents.value = text
    }
}
