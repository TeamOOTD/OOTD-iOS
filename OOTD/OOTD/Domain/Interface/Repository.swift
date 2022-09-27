//
//  Repository.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import UIKit

protocol Repository {
    // 제네릭하게 구성
    associatedtype EntityObject: Entity
    
    // 기본적인 CRUD 기능
    func fetchAll() -> [EntityObject]
    func create(item: EntityObject) throws
    func update(item: EntityObject) throws
    func delete(item: EntityObject) throws
    
    func saveImage(filename: String, image: UIImage) throws
    func fetchImage(filename: String) throws -> UIImage?
    func deleteImage(filename: String) throws
}
