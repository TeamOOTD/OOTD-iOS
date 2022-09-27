//
//  StorageRepository.swift
//  OOTD
//
//  Created by taekki on 2022/09/19.
//

import UIKit
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
        try realm.write {
            let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
            if let item = realm.objects(RealmObject.self)
                .filter(predicate).first {
                realm.delete(item)
            }
        }
    }
    
    func saveImage(filename: String, image: UIImage) throws {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectory.appendingPathComponent(filename)
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        try data.write(to: fileURL)
    }
    
    func fetchImage(filename: String) throws -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(filename)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "favorite")
        }
    }
    
    func deleteImage(filename: String) throws {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(filename)

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
