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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var sections: [SettingViewSection] = []
        
        init(sections: [SettingViewSection]) {
            self.sections = sections
        }
    }
    
    let initialState: State
    
    init() {
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
    }
}

extension SettingViewReactor {
    static func appVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        
        return version
    }
}
