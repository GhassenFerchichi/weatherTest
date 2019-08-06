//
//  AppDatabaseConfiguration.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import RealmSwift

class AppDatabaseConfiguration {
    public static var encryptionKey: Data? = nil
    public static func databaseFilePath() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
}

class RealmConfiguration: AppDatabaseConfiguration {
    
    var realmConfiguration: Realm.Configuration
    var schemaVersion: UInt64 {
        return realmConfiguration.schemaVersion
    }
    var fileURL: URL? {
        return realmConfiguration.fileURL
    }
    var encryptionKey: Data? {
        return realmConfiguration.encryptionKey
    }
    
    init(fileURL: URL? = Realm.Configuration.defaultConfiguration.fileURL,
         inMemoryIdentifier: String? = nil,
         schemaVersion: UInt64 = 0,
         encryptionKey: Data? = nil,
         readOnly: Bool = false,
         migrationBlock: MigrationBlock? = nil,
         deleteRealmIfMigrationNeeded: Bool = false,
         objectTypes: [Object.Type]? = nil) {
        realmConfiguration = Realm.Configuration()
        if let fileURL = fileURL {
            realmConfiguration.fileURL = fileURL
        } else if let inMemoryIdentifier = inMemoryIdentifier {
            realmConfiguration.inMemoryIdentifier = inMemoryIdentifier
        }
        realmConfiguration.schemaVersion = schemaVersion
        realmConfiguration.encryptionKey = encryptionKey
        realmConfiguration.readOnly = readOnly
        realmConfiguration.migrationBlock = migrationBlock
        realmConfiguration.deleteRealmIfMigrationNeeded = deleteRealmIfMigrationNeeded
        realmConfiguration.objectTypes = objectTypes
    }
}
