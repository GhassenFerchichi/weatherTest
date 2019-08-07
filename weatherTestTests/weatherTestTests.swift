//
//  weatherTestTests.swift
//  weatherTestTests
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import XCTest
import CoreLocation

@testable import weatherTest

class weatherTestTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTodayPrevisionsFilter() {
        let todayString = Date().toDayString()
        PrevisionManager.instance.previsionsForDay(location: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), day: todayString ) { (previsionsArray, error) in
            guard let previsionsArray = previsionsArray, error == nil else {
                return
            }
            previsionsArray.forEach({ (prevision) in
                XCTAssertEqual(prevision.day, todayString)
            })
        }
    }
    
    func testWeekPrevisionsFilter() {
        let todayString = Date().toDayString()
        PrevisionManager.instance.previsionsForWeek(location: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)) { (previsionsArray, error) in
            guard let previsionsArray = previsionsArray, error == nil else {
                return
            }
            previsionsArray.forEach({ (prevision) in
                XCTAssertNotEqual(prevision.day, todayString)
            })
        }
    }
}
