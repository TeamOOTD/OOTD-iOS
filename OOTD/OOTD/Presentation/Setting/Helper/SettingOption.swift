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
            return ["백업", "복구"]
        case .etc:
            return ["앱 버전", "문의하기", "앱스토어 리뷰", "오픈 라이선스"]
        }
    }
    
    var numberOfRowInSection: Int {
        return contents.count
    }
}
