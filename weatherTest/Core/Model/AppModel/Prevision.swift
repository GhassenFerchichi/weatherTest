//
//  Prevision.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import RealmSwift

class Prevision: AppModel {
    
    //MARK: Variables
    
    public var date: String = ""
    public var temperature: Double = 0
    public var humidity: String = ""
    public var windSpeed: String = ""
    public var windDirection: String = ""
    public var cloudCoverage: Float = 0
    public var pressure: Float = 0
    public var isRaining: Bool = false
    public var day: String = ""
    public var hour: String = ""
    public var weatherStatus: WeatherStatus {
        get {
            if (self.isRaining) {
                return .rainy
            } else {
                return self.cloudCoverage > 70 ? .cloudy : .sunny
            }
        }
    }
    
    //MARK: Object init
    
    public override init() {
        super.init()
    }
    
    convenience init(date: String, temperature: Double, humidity: String, windSpeed: String, windDirection: String, cloudCoverage: Float, pressure: Float, isRaining: Bool, day: String, hour: String) {
        self.init()
        
        self.date = date
        self.temperature = temperature - 273.15
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.cloudCoverage = cloudCoverage
        self.pressure = pressure / 100
        self.isRaining = isRaining
        self.day = day
        self.hour = hour
        
    }
    
    //MARK: Realm management
    
    public required init(_ object: Object) {
        guard let prevision = object as? RealmPrevision else { fatalError("Wrong object") }
        super.init(object)
        
        self.date = prevision.date
        self.temperature = prevision.temperature
        self.humidity = prevision.humidity
        self.windSpeed = prevision.windSpeed
        self.windDirection = prevision.windDirection
        self.cloudCoverage = prevision.cloudCoverage
        self.pressure = prevision.pressure
        self.isRaining = prevision.isRaining
        self.day = prevision.day
        self.hour = prevision.hour
    }
    
    override func convertToObject(realm: Realm) -> Object {
        let realmPrevision = RealmPrevision()
        realmPrevision.date = self.date
        realmPrevision.temperature = self.temperature
        realmPrevision.humidity = self.humidity
        realmPrevision.windSpeed = self.windSpeed
        realmPrevision.windDirection = self.windDirection
        realmPrevision.cloudCoverage = self.cloudCoverage
        realmPrevision.pressure = self.pressure
        realmPrevision.isRaining = self.isRaining
        realmPrevision.day = self.day
        realmPrevision.hour = self.hour
        
        return realmPrevision
    }
    
    override func objectType() -> Object.Type {
        return RealmPrevision.self
    }
}
