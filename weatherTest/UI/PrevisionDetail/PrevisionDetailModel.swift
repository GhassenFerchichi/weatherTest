//
//  PrevisionDetailModel.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit

class PrevisionDetailModel: NSObject {
    
    enum ResultState {
        case error(String)
        case prevision(data: Prevision, cityName: String)
        case loading
    }
    
    // MARK: Variables
    
    var prevision: Prevision?
    var cityName: String = ""
    var publishResult: ((ResultState) -> ())?
    
    // MARK: Life cycle methods
    
    func onViewAppeard() {
        self.publishResult?(.loading)
        if let prevision = self.prevision{
            self.publishResult?(.prevision(data: prevision, cityName: self.cityName))
        } else {
            self.publishResult?(.error(NSLocalizedString("Could not retrieve previsions for this day", comment: "")))
        }
    }
}
