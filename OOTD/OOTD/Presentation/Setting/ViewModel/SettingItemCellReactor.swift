//
//  SettingItemCellReactor.swift
//  OOTD
//
//  Created by taekki on 2022/10/06.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingItemCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var title: String?
        var detail: String?
        var isUnderlineHidden: Bool = false
    }
    
    let initialState: State
    
    init(
        title: String?,
        detail: String?,
        isUnderlineHidden: Bool = false
    ) {
        self.initialState = State(title: title, detail: detail, isUnderlineHidden: isUnderlineHidden)
    }
}
