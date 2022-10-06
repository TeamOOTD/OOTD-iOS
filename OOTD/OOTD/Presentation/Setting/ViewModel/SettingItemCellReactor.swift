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
    }
    
    let initialState: State
    
    init(title: String?) {
        self.initialState = State(title: title)
        _ = self.state
    }
}
