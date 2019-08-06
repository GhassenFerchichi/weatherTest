//
//  RealmOperations.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmDeletableObject: class {
    func objectsToRemoveWhenRemovingObject(realm: Realm) -> [Object]
}

class RealmOperation: AppDatabaseOperation {
    typealias AppDatabaseType = RealmOperation
    
    private var realm: Realm!
    
    required init?(_ configuration: AppDatabaseConfiguration) {
        do {
            try self.configure(configuration)
        } catch let error {
            Log.error(error)
            return nil
        }
    }
    
    func configure(_ configuration: AppDatabaseConfiguration) throws {
        guard let realmConfig = (configuration as? RealmConfiguration)?.realmConfiguration else { throw AppDatabaseError.WrongDatabaseConfigurtaion }
        do {
            realm = try Realm(configuration: realmConfig)
        } catch let error {
            throw AppDatabaseError.CannotCreateRealmInstance(reason: error)
        }
    }
    
    // MARK: Transactions
    func startTransaction() {
        if !realm!.isInWriteTransaction {
            realm!.beginWrite()
        }
    }
    
    func commitTransaction() throws {
        if realm!.isInWriteTransaction {
            do {
                try realm!.commitWrite()
            } catch _ {
                throw AppDatabaseError.CannotWriteInRealmDatabase
            }
        } else {
            throw AppDatabaseError.NotInWriteTransaction
        }
    }
    
    func cancelTransaction() {
        if realm!.isInWriteTransaction {
            realm!.cancelWrite()
        }
    }
    
    
    // MARK: Find
    func find<T: AppModel>(_ model: T, filterPredicate: NSPredicate? = nil, filterString: String? = nil, sortByKeyPath: String? = nil, ascending: Bool = true, limit: Int = 0, offset: Int = 0) -> [T] {
        let type = model.objectType()
        var results = realm!.objects(type)
        if let f = filterPredicate {
            results = results.filter(f)
        } else if let f = filterString {
            results = results.filter(f)
        }
        if let s = sortByKeyPath {
            results = results.sorted(byKeyPath: s, ascending: ascending)
        }
        if limit > 0 || offset > 0 {
            let count = results.count
            var limitedResults = [T]()
            //If there is a limit argument, then check if we won't try to access out of the bounds of results. Otherwise, no limit means all results
            let realLimit = limit > 0 ? ((offset+limit) > count ? count : (offset+limit)) : count
            if offset <= realLimit {
                for i in offset..<realLimit {
                    limitedResults.append(T(results[i]))
                }
            }
            return limitedResults
        }
        return results.map { T($0) }    //Map is faster than using for iter. That's why if there is no limit nor offset, use Swift's built-in map
    }
    
    func find<T: AppModel, K>(_ model: T, forPrimaryKey primaryKey: K) -> T? {
        let type = model.objectType()
        if let obj = realm!.object(ofType: type, forPrimaryKey: primaryKey) {
            return T(obj)
        } else {
            return nil
        }
    }
    
    
    // MARK: Count
    func count<T : AppModel>(_ model: T, filterPredicate: NSPredicate?, filterString: String?) -> Int {
        let type = model.objectType()
        var results = realm!.objects(type)
        if let f = filterPredicate {
            results = results.filter(f)
        } else if let f = filterString {
            results = results.filter(f)
        }
        return results.count
    }
    
    // MARK: Add
    func create<T: AppModel>(_ model: T) throws {
        realm!.add(model.convertToObject(realm: realm!))
    }
    
    // MARK: Update
    func updateOrCreate<T: AppModel>(_ model: T) throws {
        realm!.add(model.convertToObject(realm: realm!), update: true)
    }
    
    // MARK: Delete
    /**
     Delete a model
     
     - Note: Realm can only delete a reference from Realm itself and as we manipulate AppModel, Realm cannot delete the custom models. So we need to do 2 operations: Fetch from Realm and delete what we fetched
     */
    func delete<T: ModelRealmable>(_ model: T) throws {
        guard let pk = model.primaryKey else { throw AppDatabaseError.MissingPrimaryKey }
        guard let realmModel = realm!.object(ofType: model.objectType(), forPrimaryKey: pk) else { return }
        var objectsToRemove: [Object] = [realmModel]
        if let deletableModel = realmModel as? RealmDeletableObject {
            objectsToRemove.append(contentsOf: deletableModel.objectsToRemoveWhenRemovingObject(realm: realm))
        }
        realm!.delete(objectsToRemove)
    }
    
    /**
     Delete models
     
     - Note: Realm can only delete a reference from Realm itself and as we manipulate AppModel, Realm cannot delete the custom models. So we need to do 2 operations: Fetch from Realm and delete what we fetched
     */
    func delete<S: Sequence>(_ models: S) throws where S.Iterator.Element: ModelRealmable {
        for model in models {
            guard let pk = model.primaryKey else { throw AppDatabaseError.MissingPrimaryKey }
            guard let realmModel = realm!.object(ofType: model.objectType(), forPrimaryKey: pk) else { continue }
            var objectsToRemove: [Object] = [realmModel]
            if let deletableModel = realmModel as? RealmDeletableObject {
                objectsToRemove.append(contentsOf: deletableModel.objectsToRemoveWhenRemovingObject(realm: realm))
            }
            realm!.delete(objectsToRemove)
        }
    }
    
    func emptyDatabase() throws {
        realm!.deleteAll()
    }
}
