//
//  ProjectArchiveViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit
import PhotosUI

import OOTD_Core
import OOTD_UIKit
import RxSwift

final class ProjectArchiveViewController: BaseViewController {
    
    private var viewModel: ProjectArchiveViewModel
    private lazy var adapter: ProjectArchiveCollectionViewAdapter = {
        let adapter = ProjectArchiveCollectionViewAdapter(collectionView: rootView.collectionView, adapterDataSource: viewModel, delegate: self)
        return adapter
    }()
    
    private let rootView = ProjectArchiveView()
    
    var disposedBag = DisposeBag()
    
    init(viewModel: ProjectArchiveViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func bind() {
        adapter.adapterDataSource = viewModel
        
        viewModel.isValid
            .bind(to: rootView.navigationBar.rightButton.rx.isEnabled)
            .disposed(by: disposedBag)
        
        viewModel.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: rootView.navigationBar.rightButton.rx.alpha)
            .disposed(by: disposedBag)
        
        viewModel.isEditMode
            .map { $0 ? false : true }
            .bind(to: rootView.navigationBar.deleteButton.rx.isHidden)
            .disposed(by: disposedBag)
        
        rootView.navigationBar.leftButton.rx.tap
            .subscribe { [weak self] _ in
                self?.popViewController()
            }.disposed(by: disposedBag)
        
        rootView.navigationBar.rightButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.saveProject()
                self?.popViewController()
            }.disposed(by: disposedBag)
        
        rootView.navigationBar.deleteButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentAlert(title: "정말 삭제하실건가요?", isIncludedCancel: true) { _ in
                    self?.viewModel.deleteProject()
                    self?.popViewController()
                }
            }.disposed(by: disposedBag)
    }
}

extension ProjectArchiveViewController {
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProjectArchiveViewController: ProjectArchiveCollectionViewAdapterDelegate {
    
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.collectionView.performBatchUpdates(nil)
        }
    }
    
    func startDateButtonTapped(date: Date?) {
        pickDate("startDate", title: "시작일을 선택해주세요.", date: date)
    }
    
    func endDateButtonTapped(date: Date?) {
        self.presentAlert(
            title: "진행 중인 프로젝트인가요?",
            message: "종료된 프로젝트라면 종료일을 선택해주세요.",
            isIncludedCancel: true,
            okActionTitle: "네",
            cancelActionTitle: "아니오",
            okCompletion: { _ in
                NotificationCenter.default.post(name: NSNotification.Name("endDate"), object: nil)
            }, cancelCompletion: { [weak self] _ in
                self?.pickDate("endDate", title: "종료일을 선택해주세요.", date: date)
            })
    }
    
    private func pickDate(_ dateKey: String, title: String, date: Date?) {
        var selectedDate: Date?
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        alertController.addDatePicker(style: .wheels, date: date) { date in
            selectedDate = date
        }
        
        alertController.addAction(UIAlertAction(title: "선택 완료", style: .cancel) { _ in
            NotificationCenter.default.post(name: NSNotification.Name(dateKey), object: nil, userInfo: ["selectedDate": selectedDate as Any])
        })
        
        present(alertController, animated: true)
    }
    
    func selectPhoto() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ProjectArchiveViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("pickLogo"), object: nil, userInfo: ["logo": image as Any])
                }
            }
        }
    }
}
