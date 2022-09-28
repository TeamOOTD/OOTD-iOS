//
//  License.swift
//  OOTD
//
//  Created by taekki on 2022/09/28.
//

enum License: String, CaseIterable {
    case fscalendar             = "FSCalendar"
    case iqKeyboardManagerSwift = "IQKeyboardManagerSwift"
    case realm                  = "Realm"
    case rxSwift                = "RxSwift"
    case snapKit                = "SnapKit"
    case then                   = "Then"
    case wsTagsField            = "WSTagsField"
}

extension License {
    var urlString: String {
        switch self {
        case .fscalendar:
            return "https://github.com/WenchaoD/FSCalendar.git"
        case .iqKeyboardManagerSwift:
            return "https://github.com/WenchaoD/FSCalendar.git"
        case .realm:
            return "https://github.com/realm/realm-swift.git"
        case .rxSwift:
            return "https://github.com/ReactiveX/RxSwift.git"
        case .snapKit:
            return "https://github.com/SnapKit/SnapKit.git"
        case .then:
            return "https://github.com/devxoul/Then.git"
        case .wsTagsField:
            return "https://github.com/whitesmith/WSTagsField.git"
        }
    }
}
