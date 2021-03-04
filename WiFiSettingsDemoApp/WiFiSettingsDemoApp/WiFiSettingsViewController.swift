//
//  WiFiSettingsViewController.swift
//  WiFiSettingsDemoApp
//
//  Created by Azadeh Richter on 03.03.21.
//

import UIKit

class WiFiSettingsViewController: UIViewController {

    enum Section: CaseIterable {
        case config, networks
    }
    
    enum ItemType {
        case wifiEnabled, currentNetwork, availableNetwork
    }
    
    struct Item: Hashable {
        let title: String
        let type: ItemType
        
        init(title: String, type: ItemType) {
            self.title = title
            self.type = type
            self.identifier = UUID()
        }
        
        init(network: WiFiController.Network) {
            self.title = network.name
            self.type = .availableNetwork
            self.identifier = network.identifier
        }
        
        private let identifier: UUID
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    var wifiController: WiFiController! = nil
    
    static let reuseIdentifier = "reuse-identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wi-Fi"
        configureTableView()
        configureDataSource()
        updateUI(animated: true)
    }
}

// MARK: - Table View extension
extension WiFiSettingsViewController {
    
    func configureDataSource() {
        wifiController = WiFiController()
        
        self.dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: WiFiSettingsViewController.reuseIdentifier, for: indexPath)
            
            // Configure cell
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            
            cell.contentConfiguration = content
            return cell
        })
        
        self.dataSource.defaultRowAnimation = .fade
    }
    
    func updateUI(animated: Bool) {
        guard let controller = self.wifiController else { return }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let sortedNetworks = controller.availableNetworks.sorted { $0.name < $1.name }
        let networkItems = sortedNetworks.map { Item(network: $0) }
        currentSnapshot.appendSections([.networks])
        currentSnapshot.appendItems(networkItems, toSection: .networks)
        
        dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
}

// MARK: - UI extension
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

