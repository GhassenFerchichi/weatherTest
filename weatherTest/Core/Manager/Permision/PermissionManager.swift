//
//  PermissionManager.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import CoreLocation

public enum AuthorizationType {
    case location
}

public enum AuthorizationStatus {
    case notAsked
    case restricted
    case unauthorized
    case authorized
}

public typealias AuthorizationResponse = ((AuthorizationStatus) -> (Void))

public class PermissionManager: NSObject {
    public static let instance = PermissionManager()
    private var locationCompletion: AuthorizationResponse?
    
    //MARK: Object lifecycle
    
    private override init() {
        super.init()
    }
    
    //MARK: Authorization management
    
    public func askForAuthorization(_ authorization: AuthorizationType, completion: @escaping AuthorizationResponse) {
        authorizationStatus(authorization) { (status) -> (Void) in
            
            if status == .notAsked {
                switch authorization {
                case .location:
                    self.askForLocationAuthorization(completion: completion)
                }
            } else {
                completion(status)
            }
        }
    }
    
    public func authorizationStatus(_ authorization: AuthorizationType, completion: @escaping AuthorizationResponse) {
        switch authorization {
        case .location:
            locationAuthorizationStatus(completion: completion)
        }
    }
    
    //MARK: Location
    
    private func locationAuthorizationStatus(completion: AuthorizationResponse) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            completion(.notAsked)
        case .denied, .restricted:
            completion(.unauthorized)
        case .authorizedAlways, .authorizedWhenInUse:
            completion(.authorized)
        @unknown default:
            completion(.notAsked)
        }
    }
    
    private func askForLocationAuthorization(completion: @escaping AuthorizationResponse) {
        locationCompletion = completion
        LocationManager.instance.askForLocationLocationAuthorization()
    }
    
    public func onLocationAuthorizationStatusChanged(status: CLAuthorizationStatus) {
        guard status != .notDetermined else {
            return
        }
        if let locationCompletion = locationCompletion {
            locationAuthorizationStatus(completion: locationCompletion)
            self.locationCompletion = nil
        }
    }
}
