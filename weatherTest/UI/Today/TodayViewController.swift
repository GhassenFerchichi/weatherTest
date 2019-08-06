//
//  TodayViewController.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//


import UIKit
import CoreLocation
import MBProgressHUD

class TodayViewController: UIViewController {
    
    // MARK: Variables
    
    var userLocation: CLLocationCoordinate2D?
    var searchTextField: UITextField?
    var previsions = [Prevision] () {
        didSet {
            self.collectionView.reloadData()
            self.errorLabel.isHidden = !self.previsions.isEmpty
        }
    }
    
    private lazy var viewModel = {
        TodayViewModel()
    }()
    
    // MARK: IBOutlets implementation
    
    @IBOutlet private weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.observeViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewAppeared()
    }
    
    // MARK: Setup user interface
    
    private func setupUI() {
        self.searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width / 2 - 30, height: 30))
        self.searchTextField?.textAlignment = .center
        self.searchTextField?.layer.cornerRadius = 5
        self.searchTextField?.layer.borderWidth = 1
        self.searchTextField?.layer.borderColor = UIColor.white.cgColor
        self.searchTextField?.textColor = .white
        self.searchTextField?.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(onSearchTap))
        
        self.errorLabel.text = NSLocalizedString("Could not get Weather previsions.\nPlease try again later", comment: "")
        
        self.navigationItem.titleView = self.searchTextField
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            self.viewTopConstraint.constant = -(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) - (self.navigationController?.navigationBar.bounds.height ?? 0)
        } else {
            self.viewTopConstraint.constant = -(self.navigationController?.navigationBar.bounds.height ?? 0)
        }
        self.collectionView.register(UINib(nibName: kWeatherCollectionViewNibName, bundle: nil), forCellWithReuseIdentifier: kWeatherCollectionViewCellIdentifier)
    }
    
    // MARK: Button actions
    
    @IBAction func onLoctionButtonTap(_ sender: Any) {
        self.viewModel.onLocationTap()
    }
    
    @IBAction func onSearchTap(_ sender: Any) {
        guard let searchText = searchTextField?.text, !searchText.isEmpty else {
            self.showError(NSLocalizedString("Please enter a city name.", comment: ""))
            return
        }
        self.viewModel.onSearchAdressTap(searchText)
    }
    
    // MARK: ViewModel Subscription
    
    func observeViewModel() {
        self.viewModel.publishResult = {
            result in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .error:
                self.setNowPrevision(nil)
                self.previsions = []
                break
            case .previsions(let current, let todayPrevisions):
                self.previsions = todayPrevisions
                self.setNowPrevision(current)
            case .loading:
                MBProgressHUD.showAdded(to: self.view, animated: true)
            case .placeName(let name):
                self.searchTextField?.text = name
                self.searchTextField?.resignFirstResponder()
            case .unAuthorized:
                self.showUserLocationAuthorizationError()
            }
        }
    }
    
    // MARK: Helper methods
    
    private func setNowPrevision(_ prevision: Prevision?) {
        if let prevision = prevision {
            self.currentTempLabel.text = "\(Int(prevision.temperature))°C"
            self.windDirectionLabel.text = prevision.windDirection
            self.windSpeedLabel.text = "\(prevision.windSpeed.prefix(4))km/h"
            self.humidityLabel.text = "\(prevision.humidity.prefix(4))%"
            self.weatherStatusLabel.text = prevision.weatherStatus.rawValue
            self.dateLabel.text = prevision.day.toDate().toDayOfTheWeek()
        } else {
            self.currentTempLabel.text = "-"
            self.windDirectionLabel.text = "-"
            self.windSpeedLabel.text = "-"
            self.humidityLabel.text = "-"
            self.weatherStatusLabel.text = "-"
            self.dateLabel.text = "-"
        }
    }
    
    private func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func showUserLocationAuthorizationError() {
        let alert = UIAlertController (title: "", message: "Activate ", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UICollectionView DataSource / Delegate

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.previsions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeatherCollectionViewNibName, for: indexPath) as! WeatherItemCollectionViewCell
        let prevision = self.previsions[indexPath.item]
        cell.configureCell(temperature: Float(prevision.temperature), status: prevision.weatherStatus, hour: prevision.hour, windDirection: prevision.windDirection, windSpeed: prevision.windSpeed, humidity: prevision.humidity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kWeatherCollectionViewWidth, height: kWeatherCollectionViewHeight)
    }

}
