//
//  SettingViewReactor.swift
//  OOTD
//
//  Created by taekki on 2022/10/06.
//

import Foundation

import ReactorKit
import RxCocoa
import RxSwift

final class SettingViewReactor: Reactor {
    enum Action {
        case fetch
    }
    
    enum Mutation {
        case updateProfileCard(Int, Int)
    }
    
    struct State {
        var sections: [SettingViewSection] = []
        var commit: Int = 0
        var todo: Int = 0
        
        init(sections: [SettingViewSection]) {
            self.sections = sections
        }
    }
    
    let repository: StorageRepository<Todo>
    let initialState: State
    
    init(repository: StorageRepository<Todo>) {
        let configSection = SettingViewSection.config([
            .token(SettingItemCellReactor(title: "토큰 설정", detail: nil, isUnderlineHidden: true))
        ])
          
        let dataSection = SettingViewSection.config([
            .backupAndRestore(SettingItemCellReactor(title: "백업/복구", detail: nil, isUnderlineHidden: true))
        ])
        
        let aboutSection = SettingViewSection.config([
            .license(SettingItemCellReactor(title: "오픈 라이선스", detail: nil)),
            .appVersion(SettingItemCellReactor(title: "앱 버전", detail: SettingViewReactor.appVersion(), isUnderlineHidden: true))
        ])
        
        let sections = [configSection] + [dataSection] + [aboutSection]
        self.initialState = State(sections: sections)
        self.repository = repository
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetch:
            let profileInformation = fetchProfileInformation()
            return fetchProfileInformation()
                .map {
                    Mutation.updateProfileCard($0, $1)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateProfileCard(commit, todo):
            newState.commit = commit
            newState.todo = todo
            return newState
        }
    }
}

extension SettingViewReactor {
    static func appVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        
        return version
    }
    
    private func fetchProfileInformation() -> Observable<(commit: Int, todo: Int)> {
        let emptyResult: (Int, Int) = (0, 0)
        let date = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var dateComponents = DateComponents()
        dateComponents.year = date.year
        dateComponents.month = date.month
        dateComponents.day = date.day
        
        let commit = UserDefaults.standard.integer(forKey: "todayCommit")
        guard let today = Calendar.current.date(from: dateComponents) else { return .just(emptyResult) }
        let todo = repository.fetchByDate(by: today, keyPath: "date")
        return .just((commit, todo.count))
    }
}
