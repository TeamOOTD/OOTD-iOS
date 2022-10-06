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
        
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
