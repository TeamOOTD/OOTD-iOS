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
    
    private let viewModel: TodoBottomSheetViewModelImpl
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
    private lazy var buttonContainerView = UIView()
    private lazy var buttonHStackView = UIStackView(arrangedSubviews: [doneButton, deleteButton])
    private lazy var doneButton = ODSButton(.enabled)
    private lazy var deleteButton = ODSButton(.sub)
    
    init(viewModel: TodoBottomSheetViewModelImpl) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    override func configureAttributes() {
        view.backgroundColor = .systemBackground
        
        collectionView.do {
            $0.isScrollEnabled = false
        }
        
        buttonContainerView.do {
            $0.backgroundColor = .grey100
        }
        
        buttonHStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = Spacing.s8
        }

        doneButton.do {
            $0.title = "확인"
        }
        
        deleteButton.do {
            $0.title = "삭제"
            $0.isHidden = true
            $0.actionHandler = { [weak self] in
                self?.deleteTodo()
            }
        }
        
        setupSheet()
    }
    
    override func configureLayout() {
        view.addSubviews(collectionView, buttonContainerView, buttonHStackView)

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Spacing.s32)
            $0.leading.bottom.trailing.equalToSuperview().inset(Spacing.s24)
        }
        
        buttonContainerView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(80.adjustedHeight)
        }
        
        buttonHStackView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(buttonContainerView).inset(Spacing.s24)
            $0.height.equalTo(50.adjustedHeight)
        }
    }
    
    override func bind() {
        adapter.adapterDataSource = viewModel
        
        viewModel.state.bind { [weak self] state in
            self?.deleteButton.isHidden = state == .create
            self?.doneButton.title = state == .create ? "확인" : "수정"
            self?.doneButton.actionHandler = {
                state == .create ? self?.createTodo() : self?.updateTodo()
            }
        }
        
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
    
    private func createTodo() {
        viewModel.createTodo { [weak self] in
            self?.dismiss(animated: true)
            self?.completionHandler?()
        }
    }
    
    private func updateTodo() {
        viewModel.updateTodo { [weak self] in
            self?.dismiss(animated: true)
            self?.completionHandler?()
        }
    }
    
    private func deleteTodo() {
        presentAlert(title: "정말 삭제하실건가요?", isIncludedCancel: true) { [weak self] _ in
            self?.viewModel.deleteTodo {
                self?.dismiss(animated: true)
                self?.completionHandler?()
            }
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
    
    func projectCategoryCellTapped(at index: Int) {
        if index < viewModel.projects.count {
            viewModel.projectID.value = viewModel.projects[index].0.id
        } else {
            viewModel.projectID.value = ""
        }
        self.collectionView.reloadData()
    }
}
