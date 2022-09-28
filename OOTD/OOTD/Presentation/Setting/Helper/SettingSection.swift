//
//  SettingSection.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

enum SettingSection: String, CaseIterable {
    case config
    case personal
    case etc
}

enum SettingRow: String {
    case tokenConfig = "토큰 설정"
    case backupAndRestore = "백업/복구"
    case terms = "서비스 이용 약관"
    case privacy = "개인정보 처리방침"
    case license = "오픈 라이선스"
    case appVersion = "앱 버전"
}

extension SettingSection {
    
    var contents: [SettingRow] {
        switch self {
        case .config:
            return [.tokenConfig]
        case .personal:
            return [.backupAndRestore]
        case .etc:
            return [.license, .appVersion]
        }
    }
    
    var numberOfRowInSection: Int {
        return contents.count
    }
}
