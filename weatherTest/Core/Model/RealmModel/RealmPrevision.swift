//
//  RealmPrevision.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import RealmSwift

class RealmPrevision: Object {
    
    //MARK: Variables
    
    @objc dynamic var date: String = ""
    @objc dynamic var temperature: Double  = 0
    @objc dynamic var humidity: String = ""
    @objc dynamic var windSpeed: String = ""
    @objc dynamic var windDirection: String = ""
    @objc dynamic var cloudCoverage: Float = 0
    @objc dynamic var pressure: Float = 0
    @objc dynamic var isRaining: Bool = false
    @objc dynamic var day: String = ""
    @objc dynamic var hour: String = ""
    
    /**
     Override Object.primaryKey() to set the model’s primary key. Declaring a primary key allows objects to be looked up and updated efficiently and enforces uniqueness for each value.
     */
    override public static func primaryKey() -> String? {
        return "date"
    }
    
    //MARK: Convenience init
    
    convenience init(date: String, temperature: Double, humidity: String, windSpeed: String, windDirection: String, cloudCoverage: Float, pressure: Float, isRaining: Bool, day: String, hour: String) {
        self.init()
        
        self.date = date
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.cloudCoverage = cloudCoverage
        self.pressure = pressure
        self.isRaining = isRaining
        self.day = day
        self.hour = hour
    }
}
