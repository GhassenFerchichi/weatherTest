//
//  PrevisionMapper.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import SwiftyJSON

class PrevisionMapper: NSObject {
    static let instance = PrevisionMapper()
    
    //MARK: Parsing dictionary
    
    /// This function returns a parsed previsions array from passed previsions json array
    ///
    /// - Parameter previsionsJson: Previsions JSON array.
    ///
    /// - Returns: Prevision array.
    
    func weatherListFromDictionary(previsionsJson: JSON) -> [Prevision] {
        var previsionsArray: [Prevision] = []
        
        // Retrieve only days from previsions json dictionary and sort by ascending date
        let filteredPrevisionJson = previsionsJson.filter({ key, value -> Bool in
            key.split(separator: " ").count == 2
        }).sorted(by: { (first: (key: String, value: JSON), second: (key: String, value: JSON)) -> Bool in
            return first.key.toDate() < second.key.toDate()
        })
        
        //  Parsing previsions json dictionary
        filteredPrevisionJson.forEach({ (date,prevision) in
            let prevision = Prevision(date: date.toDate().toDateString(),
                                      temperature: prevision["temperature"]["sol"].doubleValue,
                                      humidity: prevision["humidite"]["2m"].stringValue,
                                      windSpeed: prevision["vent_moyen"]["10m"].stringValue,
                                      windDirection: prevision["vent_direction"]["10m"].stringValue,
                                      cloudCoverage: prevision["nebulosite"]["totale"].floatValue,
                                      pressure: prevision["pression"]["niveau_de_la_mer"].floatValue,
                                      isRaining: prevision["pluie"].boolValue,
                                      day: date.toDate().toDayString(),
                                      hour: date.toDate().toHourMinuteString())
            
            previsionsArray.append(prevision)
        })
        
        return previsionsArray
    }
}
