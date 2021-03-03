//
//  WiFiSettingsViewController.swift
//  WiFiSettingsDemoApp
//
//  Created by Azadeh Richter on 03.03.21.
//

import UIKit

class WiFiSettingsViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    static let reuseIdentifier = "reuse-identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wi-Fi"
        configureTableView()
    }


}

// MARK: - UI extensions
extension WiFiSettingsViewController {
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: WiFiSettingsViewController.reuseIdentifier)
    }
}

