//
//  StorageRepository.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import Foundation
import RealmSwift

class StorageRepository<RepositoryObject>: Repository
        where RepositoryObject: Entity,
              RepositoryObject.StoreType: Object {
    
    typealias RealmObject = RepositoryObject.StoreType
    
    private let realm: Realm

    init() {
        realm = try! Realm()
    }

    func fetchAll() -> [RepositoryObject] {
        let objects = realm.objects(RealmObject.self)
        return objects.compactMap { $0.model as? RepositoryObject }
    }
    
    func create(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toStorable())
        }
    }

    func update(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toStorable(), update: .modified)
        }
    }

    func delete(item: RepositoryObject) throws {
        print(item.toStorable().uuid)
        try realm.write {
            let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
            if let item = realm.objects(RealmObject.self)
                .filter(predicate).first {
                realm.delete(item)
            }
        }
    }
}
