//
//  AppModel.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import RealmSwift

protocol ModelRealmable {
    func convertToObject(realm: Realm) -> Object
    func objectType() -> Object.Type
    var primaryKey: String? { get }
}

public class AppModel: ModelRealmable {
    public var id: String = UUID().uuidString
    
    //MARK: Object init
    
    public init() {}
    
    required public init(_ object: Object) {}
    
    //MARK: - ModelRealmable
    
    var primaryKey: String? {
        return self.id
    }
    
    func convertToObject(realm: Realm) -> Object {
        let functionName = #function
        fatalError("Base class `Model` does not support `\(functionName)`. Subclass must override this method.")
    }
    
    func objectType() -> Object.Type {
        let functionName = #function
        fatalError("Base class `Model` does not support `\(functionName)`. Subclass must override this method.")
    }
}
