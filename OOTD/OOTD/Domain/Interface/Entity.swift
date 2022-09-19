//
//  Entity.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

// DB에 저장할 모델들이 채택해야 하는 프로토콜
// storable하게 바꿔주는 행동 필요
protocol Entity {
    associatedtype StoreType: Storable
    
    func toStorable() -> StoreType
}

// 실 데이터를 DB에 저장하기 위해서 Storable 프로토콜 사용
protocol Storable {
    associatedtype EntityObject: Entity
    
    var model: EntityObject { get }
}
