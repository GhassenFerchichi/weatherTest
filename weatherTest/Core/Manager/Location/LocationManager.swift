//
//  LocationManager.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: Variables
    
    public static let instance = LocationManager()
    private let manager = CLLocationManager()
    private var locationCompletion: ((CLLocationCoordinate2D?) -> (Void))?
    
    var currentLocation: CLLocationCoordinate2D?
    
    var didAskForUserLocation: Bool {
        return UserDefaults.standard.bool(forKey: kDidAskForLocation)
    }
    
    //MARK: Object lifecycle
    
    private override init() {
        super.init()
        self.setup()
    }
    
    //MARK: Setup
    
    func setup () {
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = kCLDistanceFilterNone
        self.manager.pausesLocationUpdatesAutomatically = true
    }
    
    //MARK: Location management
    
    /// This function returns current user location coordinates
    ///
    /// - Warning: The returned location can be nil.
    ///
    /// - Returns: Current user location coordinates.
    
    public func requestCurrentLocation(completion: ((CLLocationCoordinate2D?) -> (Void))?) {
        guard locationCompletion == nil else {
            completion?(nil)
            return
        }
        UserDefaults.standard.set(true, forKey: kDidAskForLocation)
        PermissionManager.instance.askForAuthorization(.location) { (status) -> (Void) in
            if status == .authorized {
                self.locationCompletion = completion
                self.manager.startUpdatingLocation()
            } else {
                completion?(nil)
            }
        }
    }
    
    //MARK: Geocoder
    
    /// This function returns location infomration for a passed coordinates
    ///
    /// - Parameter Coordinates: Location coordinates.
    ///
    /// - Returns: Location information.
    
    public func getLocationInformations(coordinates: CLLocationCoordinate2D, completion: @escaping ((CLPlacemark?) -> (Void))) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (places, error) in
            completion(places?.first)
        }
    }
    
    /// This function returns city location coordinates
    ///
    /// - Warning: The returned location can be nil.
    ///
    /// - Parameter Name: City name.
    ///
    /// - Returns: City location coordinates.
    
    public func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                Log.error("Error in \(#function) - unabled geocode address: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                Log.error("Error in \(#function) - placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                Log.error("Error in \(#function) - unabled to retrieve location")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(location.coordinate)
            }
        }
    }
    
    //MARK: Authorization
    
    /// Request location authorization
    public func askForLocationAuthorization() {
        DispatchQueue.main.async {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: Location manager delegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.manager.stopUpdatingLocation()
            locationCompletion?(newLocation.coordinate)
            locationCompletion = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(nil)
        locationCompletion = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        PermissionManager.instance.onLocationAuthorizationStatusChanged(status: status)
    }
    
    //MARK: Location manager user defaults
    
    /// This function saves user location in user defaults
    ///
    /// - Parameter Coordinates: User location.
    
    func saveUserLocation(_ coordinates: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinates.latitude, forKey: kSavedLocationLatitude)
        UserDefaults.standard.set(coordinates.longitude, forKey: kSavedLocationLongitude)
    }
    
    /// This function returns user location from user defaults
    ///
    /// - Warning: The returned location can be nil.
    ///
    /// - Returns: User location coordinates.
    
    func getSavedLocation() -> CLLocationCoordinate2D? {
        let longitude = UserDefaults.standard.double(forKey: kSavedLocationLongitude)
        let latitude = UserDefaults.standard.double(forKey: kSavedLocationLatitude)
        if longitude != 0 || latitude != 0 {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            return nil
        }
    }
    
}
