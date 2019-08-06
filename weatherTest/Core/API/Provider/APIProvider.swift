//
//  APIProvider.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIProvider: NSObject {
    static let instance = APIProvider()
    
    // MARK: Request
    
    public func getPrevisions(_ baseUrl: String = weatherApiUrl, completion: @escaping (_ previsionArray: [Prevision]?, _ error: Error?) -> ()) {
        // Fetch the data
        Alamofire.request(baseUrl).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            // Success
            case .success(let response):
                let jsonResponse = JSON(response)
                
                // Parse JSON
                let previsionArray: [Prevision] = PrevisionMapper.instance.weatherListFromDictionary(previsionsJson: jsonResponse)
                
                completion(previsionArray, nil)
                return
                
            // Failure
            case .failure(let error):
                Log.error("APIProvider: Cannot get web service (\(error.localizedDescription))")
                completion(nil, error)
                return
            }
        })
    }
}
