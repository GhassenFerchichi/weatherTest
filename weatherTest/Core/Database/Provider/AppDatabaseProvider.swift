//
//  AppDatabaseProvider.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import RealmSwift

enum AppDatabaseError: Error {
    case WrongDatabaseConfigurtaion
    case NotInWriteTransaction
    case CannotCreateRealmInstance(reason: Error)
    case CannotWriteInRealmDatabase
    case MissingPrimaryKey
    case WrongType
}

class AppDatabaseProvider<T: AppDatabaseOperation> {
    
    private var dbElement: T
    
    init?(_ configuration: AppDatabaseConfiguration) {
        guard let dbInstance = T(configuration) else {
            return nil
        }
        dbElement = dbInstance
    }
    
    
    // MARK: Transactions
    func startTransaction() {
        dbElement.startTransaction()
    }
    
    func cancelTransaction() {
        dbElement.cancelTransaction()
    }
    
    func commitTransaction() throws {
        try dbElement.commitTransaction()
    }
    
    // MARK: Find
    func find<T: AppModel>(_ model: T, filterPredicate: NSPredicate? = nil, filterString: String? = nil, sortByKeyPath: String? = nil, ascending: Bool = true, limit: Int = 0, offset: Int = 0) -> [T] {
        return dbElement.find(model, filterPredicate: filterPredicate, filterString: filterString, sortByKeyPath: sortByKeyPath, ascending: ascending, limit: limit, offset: offset)
    }
    
    func find<T: AppModel, K>(_ model: T, forPrimaryKey primaryKey: K) -> T? {
        return dbElement.find(model, forPrimaryKey: primaryKey)
    }
    
    // MARK: Count
    func count<T : AppModel>(_ model: T, filterPredicate: NSPredicate? = nil, filterString: String? = nil) -> Int {
        return dbElement.count(model, filterPredicate: filterPredicate, filterString: filterString)
    }
    
    
    // MARK: Add
    func create<T: AppModel>(_ model: T) throws {
        defer {
            cancelTransaction()
        }
        startTransaction()
        try dbElement.create(model)
        try commitTransaction()
    }
    
    // MARK: Update
    func update(block: () -> Void) throws {
        defer {
            cancelTransaction()
        }
        startTransaction()
        block()
        try dbElement.commitTransaction()
    }
    
    func updateOrCreate<T: AppModel>(_ model: T) throws {
        defer {
            cancelTransaction()
        }
        startTransaction()
        try dbElement.updateOrCreate(model)
        try commitTransaction()
    }
    
    // MARK: Delete
    func delete<T: AppModel>(_ model: T) throws {
        defer {
            cancelTransaction()
        }
        startTransaction()
        try dbElement.delete(model)
        try commitTransaction()
    }
    
    func delete<S: Sequence>(_ models: S) throws where S.Iterator.Element: AppModel {
        defer {
            cancelTransaction()
        }
        startTransaction()
        try dbElement.delete(models)
        try commitTransaction()
    }
    
    func emptyDatabase() throws {
        defer {
            cancelTransaction()
        }
        startTransaction()
        try dbElement.emptyDatabase()
        try commitTransaction()
    }
}
