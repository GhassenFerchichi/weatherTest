//
//  String+Date.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date    }
    
    func toDay(withFormat format: String = "yyyy-MM-dd")-> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
    
    func toHour(withFormat format: String = "H")-> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
}

extension Date {
    
    func toDateString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func toDayOfTheWeek(withFormat format: String = "EEEE dd/MM") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func toHourString(withFormat format: String = "H") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = format
        
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func toHourMinuteString(withFormat format: String = "h:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func toDayString(withFormat format: String = "yyyy-MM-dd") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
}
