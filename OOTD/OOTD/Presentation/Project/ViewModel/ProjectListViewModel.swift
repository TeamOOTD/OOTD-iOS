//
//  ProjectListViewModel.swift
//  OOTD
//
//  Created by taekki on 2022/09/24.
//

import RxCocoa
import RxSwift

protocol ProjectListViewModel: AnyObject {
    
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    
    // Output
    var projects: BehaviorSubject<[Project]> { get }
}

final class ProjectListViewModelImpl: ProjectListViewModel {
    
    // MARK: - Private Properties
    private let projectRepository: StorageRepository<Project>
    private let disposeBag = DisposeBag()
    
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let projects = BehaviorSubject<[Project]>(value: [])
    
    init(projectRepository: StorageRepository<Project>) {
        self.projectRepository = projectRepository
        
        bindOnViewDidLoad()
    }
    
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observe(on: MainScheduler.instance)
            .do { [weak self] _ in
                self?.fetchProjects()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func fetchProjects() {
        let projects = projectRepository.fetchAll()
        Observable.just(projects)
            .bind(to: self.projects)
            .disposed(by: disposeBag)
    }
}
