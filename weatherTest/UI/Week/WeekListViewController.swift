//
//  WeekListViewController.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeekListViewController: UIViewController {
    
    // MARK: Variables
    
    private var previsions: [Prevision] = [] {
        didSet {
            self.tableview.reloadData()
            self.errorLabel.isHidden = !self.previsions.isEmpty
        }
    }
    
    private lazy var viewModel = {
        WeekListViewModel()
    }()
    
    // MARK: IBOutlets implementation
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var errorLabel: UILabel!
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeViewModel()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewAppeard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Setup user interface
    
    private func setupUI() {
        self.errorLabel.text = NSLocalizedString("Could not get Weather previsions.\nPlease try again later", comment: "")
    }
    
    // MARK: ViewModel Subscription
    
    private func observeViewModel() {
        viewModel.publishResult = { result in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .error(let errorMessage):
                self.showError(errorMessage)
                self.previsions = []
            case .previsions(let previsions):
                self.previsions = previsions
            case .loading:
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
        }
    }
    
    // MARK: Helper methods
    
    private func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension WeekListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.previsions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeekTableViewCellIdentifier, for: indexPath) as! WeekTableViewCell
        cell.configure(status: previsions[indexPath.row].weatherStatus, temperature: Float(previsions[indexPath.row].temperature), day: previsions[indexPath.row].day)
        return cell
    }
}
