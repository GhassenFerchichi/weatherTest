//
//  AppDatabaseOperation.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import RealmSwift

protocol AppDatabaseOperation {
    associatedtype AppDatabaseType
    
    init?(_ configuration: AppDatabaseConfiguration)
    func configure(_ configuration: AppDatabaseConfiguration) throws
    
    // MARK: Transactions
    func startTransaction()
    func commitTransaction() throws
    func cancelTransaction()
    
    // MARK: Find
    func find<T: AppModel>(_ model: T, filterPredicate: NSPredicate?, filterString: String?, sortByKeyPath: String?, ascending: Bool, limit: Int, offset: Int) -> [T]
    func find<T: AppModel, K>(_ model: T, forPrimaryKey primaryKey: K) -> T?
    
    // MARK: Count
    func count<T: AppModel>(_ model: T, filterPredicate: NSPredicate?, filterString: String?) -> Int
    
    // MARK: Add
    func create<T: AppModel>(_ model: T) throws
    
    // MARK: Update
    func updateOrCreate<T: AppModel>(_ model: T) throws
    
    // MARK: Delete
    func delete<T: AppModel>(_ model: T) throws
    func delete<S: Sequence>(_ models: S) throws where S.Iterator.Element: AppModel
    func emptyDatabase() throws
}
