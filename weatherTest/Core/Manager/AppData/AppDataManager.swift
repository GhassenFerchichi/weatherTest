//
//  AppDataManager.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit
import RealmSwift

class AppDataManager: NSObject {
    static var configuration: RealmConfiguration? = nil
    
    //MARK: Configuration
    
    internal func loadDb(using: AppDatabaseProvider<RealmOperation>? = nil) -> AppDatabaseProvider<RealmOperation> {
        let db: AppDatabaseProvider<RealmOperation>!
        if using != nil {
            db = using
        } else {
            db = AppDatabaseProvider(AppDataManager.configuration!)
        }
        return db
    }
    
}
