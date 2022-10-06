//
//  SettingViewSection.swift
//  OOTD
//
//  Created by taekki on 2022/10/06.
//

import RxDataSources

enum SettingViewSection {
    case profile([SettingViewSectionItem])
    case config([SettingViewSectionItem])
    case data([SettingViewSectionItem])
    case about([SettingViewSectionItem])
}

extension SettingViewSection: SectionModelType {
    var items: [SettingViewSectionItem] {
        switch self {
        case let .profile(items): return items
        case let .config(items): return items
        case let .data(items): return items
        case let .about(items): return items
        }
    }
    
    init(original: SettingViewSection, items: [SettingViewSectionItem]) {
        switch original {
        case .profile: self = .profile(items)
        case .config: self = .config(items)
        case .data: self = .profile(items)
        case .about: self = .about(items)
        }
    }
}

enum SettingViewSectionItem: String {
    case token = "토큰 설정"
    case backupAndRestore = "백업/복구"
    case license = "오픈 라이선스"
    case appVersion = "앱 버전"
}
