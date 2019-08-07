//
//  AppDelegate.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public static var mainRealmConfiguration: RealmConfiguration? = nil
    public static var mainRealmSchemaVersion: UInt64 = 0
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Set up realm data base
        self.setupRealmDatabase()
        
        // Location manager
        _ = LocationManager.instance
        
        // Set up keyboard
        self.setupKeyboard()

        return true
    }

    //MARK: Realm management
    
    public func setupRealmDatabase() {
        AppDelegate.mainRealmConfiguration = RealmConfiguration(fileURL: AppDatabaseConfiguration.databaseFilePath(), schemaVersion: AppDelegate.mainRealmSchemaVersion, encryptionKey: AppDatabaseConfiguration.encryptionKey, migrationBlock: { (migration, oldSchemaVersion) in
            do {
                try AppDelegate.realmMigration(migration: migration, newSchemaVersion: AppDelegate.mainRealmSchemaVersion, oldSchemaVersion: oldSchemaVersion)
            } catch {
                Log.error("Unable to migrate database: \(error)")
                fatalError()
            }
        })
        AppDataManager.configuration = AppDelegate.mainRealmConfiguration
    }
    
    public static func realmMigration(migration: Migration, newSchemaVersion: UInt64, oldSchemaVersion: UInt64) throws {
        if newSchemaVersion == oldSchemaVersion {
            return
        }
        AppDelegate.migrateFromV0toV1()
    }
    
    private static func migrateFromV0toV1() {
        //TODO - Finish realm migration method
    }
    
    //MARK: IQKeyboardManager
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}

