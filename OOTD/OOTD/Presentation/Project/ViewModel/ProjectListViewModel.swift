//
//  ProjectListViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol ProjectListViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
    
    func shouldUpdateProjects()
    func fetchImage(filename: String) -> UIImage?
}

protocol ProjectListViewModelOutput {
    var projects: BehaviorRelay<[Project]> { get }
}

protocol ProjectListViewModel: ProjectListViewModelInput, ProjectListViewModelOutput {}

final class ProjectListViewModelImpl: ProjectListViewModel {
    
    // MARK: - Private Properties
    private let projectRepository: StorageRepository<Project>
    private let disposeBag = DisposeBag()
    
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let projects = BehaviorRelay<[Project]>(value: [])
    
    init(projectRepository: StorageRepository<Project>) {
        self.projectRepository = projectRepository
        
        bindOnViewDidLoad()
    }
    
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observe(on: MainScheduler.instance)
            .do { [weak self] _ in
                self?.shouldUpdateProjects()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func shouldUpdateProjects() {
        self.projects.accept(projectRepository.fetchAll())
    }
    
    func fetchImage(filename: String) -> UIImage? {
        do {
            guard let image = try projectRepository.fetchImage(filename: "\(filename).jpeg") else {
                return .icnCamera
            }
            return image
        } catch {
            print(error)
        }
        return nil
    }
}
