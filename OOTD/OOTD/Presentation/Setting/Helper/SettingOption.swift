//
//  SettingOption.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

enum SettingOption: String, CaseIterable {
    case config
    case personal
    case etc
}

extension SettingOption {
    
    var contents: [String] {
        switch self {
        case .config:
            return ["토큰 설정"]
        case .personal:
            return ["백업/복구"]
        case .etc:
            return ["약관 및 정책", "오픈 라이선스", "앱 버전"]
        }
    }
    
    var numberOfRowInSection: Int {
        return contents.count
    }
}
