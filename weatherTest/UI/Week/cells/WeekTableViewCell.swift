//
//  WeekTableViewCell.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets implementation
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.container.layer.cornerRadius = 6
    }
    
    // MARK: Configure table view cell
    
    func configure(status: WeatherStatus, temperature: Float, day: String) {
        switch status {
        case .sunny:
            weatherImageView.image = #imageLiteral(resourceName: "sun")
        case .rainy:
            weatherImageView.image = #imageLiteral(resourceName: "rain")
        case .cloudy:
            weatherImageView.image = #imageLiteral(resourceName: "cloud")
        }
        self.tempLabel.text = "\(Int(temperature))°C"
        self.dayLabel.text = day.toDay().toDayOfTheWeek()
    }
}
