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
        
        var isConfig: Bool {
            [.currentNetwork, .wifiEnabled].contains(type)
        }
        
        var isNetwork: Bool {
            type == .availableNetwork
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
    lazy var configurationItems: [Item] = {
        [Item(title: "Wi-Fi", type: .wifiEnabled),
         Item(title: "breeno-net", type: .currentNetwork)]
    }()

    static let reuseIdentifier = "reuse-identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wi-Fi"
        configureTableView()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI(animated: true)
    }
}

// MARK: - Table View extension
extension WiFiSettingsViewController {
    
    func configureDataSource() {

        self.wifiController = WiFiController { [weak self] (controller: WiFiController) in
            guard let self = self else { return }
            self.updateUI(animated: true)
        }
        
        self.dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            guard let self = self, let wifiController = self.wifiController else { return nil }
        
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: WiFiSettingsViewController.reuseIdentifier, for: indexPath)
            
            // Configure cell
            var content = cell.defaultContentConfiguration()
            if item.isNetwork {
                content.text = item.title
                cell.accessoryType = .detailDisclosureButton
                cell.accessoryView = nil
            } else if item.isConfig {
                content.text = item.title
                if item.type == .wifiEnabled {
                    let enableWiFiSwitch = UISwitch()
                    enableWiFiSwitch.isOn = wifiController.wifiEnabled
                    enableWiFiSwitch.addTarget(self, action: #selector(self.toggleWifi(_:)), for: .touchUpInside)
                    cell.accessoryView = enableWiFiSwitch
                } else {
                    cell.accessoryType = .detailDisclosureButton
                    cell.accessoryView = nil
                }
            } else {
                fatalError("Unknown item type!")
            }
            
            cell.contentConfiguration = content
            return cell
        })
        
        self.dataSource.defaultRowAnimation = .fade
    }
    
    func updateUI(animated: Bool) {
        guard let controller = self.wifiController else { return }
        
        let configItems = configurationItems.filter { !($0.type == .currentNetwork && !controller.wifiEnabled) }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        currentSnapshot.appendSections([.config])
        currentSnapshot.appendItems(configItems, toSection: .config)
        
        if controller.wifiEnabled {
            let sortedNetworks = controller.availableNetworks.sorted { $0.name < $1.name }
            let networkItems = sortedNetworks.map { Item(network: $0) }
            currentSnapshot.appendSections([.networks])
            currentSnapshot.appendItems(networkItems, toSection: .networks)
        }
    
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
    
    @objc
    func toggleWifi(_ wifiEnabledSwitch: UISwitch) {
        wifiController.wifiEnabled = wifiEnabledSwitch.isOn
        updateUI(animated: true)
    }
}

