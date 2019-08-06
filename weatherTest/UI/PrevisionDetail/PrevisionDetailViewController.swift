//
//  PrevisionDetailViewController.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit
import MBProgressHUD

class PrevisionDetailViewController: UIViewController {
    
    // MARK: IBOutlets implementation
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cloudCoverageLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    
    // MARK: Variables
    
    lazy var viewModel = {
        PrevisionDetailModel()
    }()
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewAppeard()
    }
    
    // MARK: Setup user interface
    
    private func setupUI(prevision: Prevision, cityName: String) {
        self.dateLabel.text = prevision.day.toDay().toDayOfTheWeek() + "\n\(prevision.date.toDate().toHourMinuteString())"
        self.temperatureLabel.text = "\(Float(prevision.temperature)) °C"
        self.cloudCoverageLabel.text = "\(prevision.cloudCoverage) %"
        self.humidityLabel.text = "\(prevision.humidity.prefix(4)) %"
        self.pressureLabel.text = "\(prevision.pressure) hpa"
        self.windSpeedLabel.text = "\(prevision.windSpeed) km/h"
        self.windDirectionLabel.text = prevision.windDirection
        
        switch prevision.weatherStatus {
        case .cloudy:
            self.weatherImageView.image = #imageLiteral(resourceName: "cloud")
        case .sunny:
            self.weatherImageView.image = #imageLiteral(resourceName: "sun")
        case .rainy:
            self.weatherImageView.image = #imageLiteral(resourceName: "rain")
        }
        
        // Navigation title
        let cityLabel = UILabel()
        cityLabel.text = cityName
        self.navigationItem.titleView = cityLabel
    }
    
    // MARK: ViewModel Subscription
    
    private func observeViewModel() {
        viewModel.publishResult = { result in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .error(let errorMessage):
                self.showError(errorMessage)
            case .prevision(let prevision, let cityName):
                self.setupUI(prevision: prevision, cityName: cityName)
            case .loading:
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
        }
    }
    
    // MARK: Helper methods
    
    private func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

