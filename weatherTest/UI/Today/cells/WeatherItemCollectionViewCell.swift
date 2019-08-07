//
//  WeatherItemCollectionViewCell.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit

class WeatherItemCollectionViewCell: UICollectionViewCell {

    // MARK: Variables
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // MARK: Configure cell

    func configureCell(temperature: Float, status: WeatherStatus, hour: String, windDirection: String, windSpeed: String, humidity: String) {
        self.tempLabel.text = "\(temperature)°C"
        self.hourLabel.text = hour
        self.humidityLabel.text = "\(humidity.prefix(4))%"
        self.windSpeedLabel.text = "\(windSpeed.prefix(4))km/h"
        self.windDirectionLabel.text = windDirection
        switch status {
        case .cloudy:
            weatherImageView.image = #imageLiteral(resourceName: "cloud")
        case .sunny:
            weatherImageView.image = #imageLiteral(resourceName: "sun")
        case .rainy:
            weatherImageView.image = #imageLiteral(resourceName: "rain")
        }
    }
}

// MARK: Weather status enum

enum WeatherStatus: String, CaseIterable {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
}
