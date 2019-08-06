//
//  TodayViewModel.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation
import CoreLocation

class TodayViewModel: NSObject {
    
    enum ResultState {
        case error
        case previsions(current: Prevision, todayPrevisions: [Prevision])
        case loading
        case placeName(String)
        case unAuthorized(String)
    }
    
    // MARK: Variables

    var publishResult: ((ResultState) -> ())?
    
    // MARK: Life cycle methods

    func onViewAppeared() {
        if LocationManager.instance.currentLocation != nil {
            return
        }
        
        if let coordinates = LocationManager.instance.getSavedLocation() {
            loadPrevisionWithLocation(coordinates)
        } else if !LocationManager.instance.didAskForUserLocation {
            getUserLocation()
        } else {
            self.publishResult?(.error)
        }
    }

    // MARK: Prevision fetch

    /// This function returns the current hour prevision and the following hours
    ///
    /// - Parameter coordinates: Location coordinates.
    ///
    func loadPrevisionWithLocation(_ coordinates: CLLocationCoordinate2D) {
        // Start progress loading
        self.publishResult?(.loading)
        
        // Update current location
        LocationManager.instance.currentLocation = coordinates
        
        // Fetch today prevision
        PrevisionManager.instance.previsionsForDay(location: coordinates, day: Date().toDayString(), completion: { [weak self] (previsionsArray, error) in
            guard var previsionsArray = previsionsArray, error == nil else {
                // Push error message
                self?.publishResult?(.error)
                return
            }
            if let prevision = self?.managePrevisions(previsionsArray) {
                // Remove current prevision from previsions array
                previsionsArray.removeAll(where: { $0.hour == prevision.hour })
                
                // Publish current prevision and the rest of today previsions
                self?.publishResult?(.previsions(current: prevision, todayPrevisions: previsionsArray))
                
                // Try to retrieve location name
                self?.getNamePlaceForLocation(coordinates)
            } else {
                // Push error message
                self?.publishResult?(.error)
            }
        })
    }
    
    /// This function returns current prevision
    ///
    /// - Parameter previsionsArray: Today previsions array.
    ///
    /// - Returns: Current prevision.
    ///
    func managePrevisions(_ previsionsArray: [Prevision]) -> Prevision? {
        var prevision: Prevision? = nil
        
        guard !previsionsArray.isEmpty else {
            return nil
        }
        for i in 1 ..< previsionsArray.count - 1 {
            let nowHour = Int(Date().toHourString()) ?? -1
            let previousInputHour = Int(previsionsArray[i - 1].hour) ?? -2
            let nextInputHour = Int(previsionsArray[i + 1].hour) ?? -3
            let currentInputHour = Int(previsionsArray[i].hour) ?? -4
            
            if nowHour < previousInputHour {
                prevision = previsionsArray[i - 1]
            } else if nowHour == currentInputHour {
                prevision = previsionsArray[i]
            } else if nowHour >= previousInputHour  && nowHour <= currentInputHour {
                prevision = nowHour == currentInputHour ? previsionsArray[i] : previsionsArray[i - 1]
            } else  if nowHour > currentInputHour  && nowHour <= nextInputHour {
                prevision = nowHour == nextInputHour ? previsionsArray[i + 1] : previsionsArray[i]
            } else if nowHour > nextInputHour {
                prevision = previsionsArray[i + 1]
            }
        }
        return prevision
    }
    
    // MARK: User location
    
    /// This function tries to retrieve the user current location
    func getUserLocation() {
        LocationManager.instance.requestCurrentLocation { [weak self] (coordinates) -> (Void) in
            DispatchQueue.main.async {
                if let coordinates = coordinates {
                    LocationManager.instance.saveUserLocation(coordinates)
                    self?.loadPrevisionWithLocation(coordinates)
                } else {
                    if !LocationManager.instance.didAskForUserLocation {
                        self?.publishResult?(.error)
                    } else {
                        self?.publishResult?(.unAuthorized(NSLocalizedString("To retrieve weather previsions for your location, turn on, device location in settings.", comment: "")))
                    }
                }
            }
        }
    }
    
    // MARK: Location geocoder

    /// This function publishes location name of passed location coordinates
    ///
    /// - Parameter location: Location coordinates.
    ///
    func getNamePlaceForLocation(_ location: CLLocationCoordinate2D) {
        LocationManager.instance.getLocationInformations(coordinates: location) { [weak self] place -> (Void) in
            if let city = place?.locality {
                UserDefaults.standard.set(city, forKey: kCityName)
                self?.publishResult?(.placeName(city))
            } else {
                let city = UserDefaults.standard.string(forKey: kCityName) ?? ""
                self?.publishResult?(.placeName(city))                
            }
        }
    }
    
    // MARK: Actions
    
    func onLocationTap() {
        self.getUserLocation()
    }
    
    /// This function returns prevision for a passed address
    ///
    /// - Parameter address: Location name.
    ///
    func onSearchAdressTap(_ address: String) {
        LocationManager.instance.getLocation(forPlaceCalled: address) { [weak self] coordinates in
            if let longitude = coordinates?.longitude, let latitude = coordinates?.latitude {
                self?.loadPrevisionWithLocation(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            } else {
                self?.publishResult?(.error)
            }
        }
    }
    
}
