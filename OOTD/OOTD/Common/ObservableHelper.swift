//
//  Observable.swift
//  OOTD
//
//  Created by taekki on 2022/09/20.
//

import Foundation

final class ObservableHelper<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ completion: @escaping((T) -> Void)) {
        completion(value)
        listener = completion
    }
}
