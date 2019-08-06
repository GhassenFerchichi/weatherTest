//
//  WeekListViewModel.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation

class WeekListViewModel: NSObject {
    
    enum ResultState {
        case error(String)
        case previsions(data: [Prevision])
        case loading
    }
    
    // MARK: Variables

    var publishResult: ((ResultState) -> ())?

    // MARK: Life cycle methods

    func onViewAppeard() {
        self.publishResult?(.loading)
        guard let coordinates = LocationManager.instance.currentLocation else {
            self.publishResult?(.error(NSLocalizedString("Could not determinate current location", comment: "")))
            return
        }
        PrevisionManager.instance.previsionsForWeek(location: coordinates) { [weak self] (previsions, error) in
            guard let previsions = previsions, error == nil else {
                self?.publishResult?(.error(NSLocalizedString("Could not retrieve previsions for this week", comment: "")))
                return
            }
            self?.publishResult?(.previsions(data: previsions))
        }
    }
}
