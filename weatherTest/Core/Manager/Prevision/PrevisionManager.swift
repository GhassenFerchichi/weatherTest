//
//  PrevisionManager.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import CoreLocation
import SwiftyJSON

class PrevisionManager: AppDataManager {
    static let instance = PrevisionManager()
    
    //MARK: Previsions refresh
    
    //MARK: Previsions filter
    
    /// This function refresh prevision array, it calls weather api and save returned data in database and if failed returns prevision array from database
    ///
    /// - Parameter location: User location.
    ///
    /// - Returns: Prevision array.
    
    private func refreshPrevisions(location: CLLocationCoordinate2D, completion: @escaping (_ previsionsArray: [Prevision]?, _ error: Error?) -> ()) {
        let url = weatherApiUrl  + String(location.latitude) + ","+String(location.longitude) + apiToken
        APIProvider.instance.getPrevisions(url) { (previsionsArray, error) in
            guard let previsionsArray = previsionsArray, error == nil else {
                
                // Unable to retrieve prevision data from API
                Log.error("PrevisionManager: Cannot retrieve previsions array from api (\(String(describing: error)))")
                
                // Retrieving previson data from database
                let fetchedPrevisionsArray = self.previsions()
                if (!fetchedPrevisionsArray.isEmpty) {
                    // Return prevision data retrieved from database
                    completion(fetchedPrevisionsArray, nil)
                    return
                }
                
                // Return error and empty previsions array
                Log.error("PrevisionManager: Empty previsions list in database")
                completion(nil, error)
                return
            }
            
            // Add previsions into database
            self.addPrevisions(previsions: previsionsArray)
            
            // Return previsions list
            completion(previsionsArray, nil)
        }
    }
    
    //MARK: Previsions filter
    
    /// This function returns a filtered previsions array for a passed day and a specific location
    ///
    /// - Parameter location: User location.
    /// - Parameter day: Day used for filer.
    /// - Parameter completion: Callback completion.
    /// - Parameter error: Error.
    ///
    /// - Returns: Prevision array.
    
    func previsionsForDay(location: CLLocationCoordinate2D, day:String, completion: @escaping (_ previsionsArray: [Prevision]?, _ error: Error?) -> ()) {
        self.refreshPrevisions(location: location, completion:  { (previsionsArray, error) in
            guard let previsionsArray = previsionsArray, error == nil else {
                // Unable to retrieve previsions array
                // Return error and empty previsions array
                Log.error("PrevisionManager: Cannot retrieve previsions array (\(String(describing: error)))")
                completion(nil, error)
                return
            }
            
            // Filter previsions array by day
            let previsionsForDay = previsionsArray.filter { (prevision) -> Bool in
                prevision.day == day
            }
            
            // Return filtered previsions array
            completion(previsionsForDay, nil)
            return
        })
    }
    
    /// This function returns a filtered by week previsions array for a specific location
    ///
    /// - Parameter location: User location.
    /// - Parameter day: Day used for filer.
    /// - Parameter completion: Callback completion.
    /// - Parameter error: Error.
    ///
    /// - Returns: Prevision array.
    
    func previsionsForWeek(location: CLLocationCoordinate2D, completion: @escaping (_ previsionsArray: [Prevision]?, _ error: Error?) -> ()) {
        self.refreshPrevisions(location: location, completion: { (previsionsArray, error) in
            guard let previsionsArray = previsionsArray, error == nil else {
                // Unable to retrieve previsions array
                // Return error and empty previsions array
                Log.error("PrevisionManager: Cannot retrieve previsions array (\(String(describing: error)))")
                completion(nil, error)
                return
            }
            
            // Filter previsions array by week
            let previsionsForWeek = previsionsArray.filter { (prevision) -> Bool in
                prevision.day.toDay() > Date().toDayString().toDay()
            }
            
            // Sort previsions ascending and grouping by day
            let previsionsrrayGroupedByDays = Dictionary(grouping: previsionsForWeek){ $0.day}.compactMap({ (arg) -> Prevision in
                return arg.value.first!
            }).sorted(by: { (prev1, prev2) -> Bool in
                prev1.day.toDay() < prev2.day.toDay()
            })
            
            // Return filtered previsions array
            completion(previsionsrrayGroupedByDays, nil)
            return
        })
    }
    
    //MARK: Prevision management
    
    /// This function returns a previsions array from realm database
    ///
    /// - Returns: Prevision array.
    
    func previsions() -> [Prevision] {
        let db = loadDb(using: nil)
        let fetchedPrevision = db.find(Prevision())
        return fetchedPrevision
    }
    
    /// This function add a previsions array into the realm database
    
    func addPrevisions(previsions: [Prevision]) {
        let db = loadDb(using: nil)
        do {
            try db.delete(previsions)
            try previsions.forEach { (prevision) in
                try db.updateOrCreate(prevision)
            }
        } catch {
            Log.error("PrevisionManager: Cannot add previsions")
        }
    }
    
    /// This function updates a specific prevision in realm database
    
    func update(previsions: [Prevision]) {
        let db = self.loadDb()
        do {
            try previsions.forEach { (prevision) in
                try db.updateOrCreate(prevision)
            }
        } catch {
            Log.error("PrevisionManager: Cannot update prevision (\(error))")
        }
    }
}
