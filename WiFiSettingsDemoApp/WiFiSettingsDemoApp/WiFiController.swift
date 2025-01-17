//
//  WiFiController.swift
//  WiFiSettingsDemoApp
//
//  Created by Azadeh Richter on 03.03.21.
//

import Foundation

class WiFiController {
    
    struct Network: Hashable {
        let name: String
        let identifier = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func ==(lhs: Network, rhs: Network) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    typealias UpdateHandler = (WiFiController) -> Void
    
    private let updateHandler: UpdateHandler
    
    init(updateHandler: @escaping UpdateHandler) {
        self.updateHandler = updateHandler
        updateAvailableNetworks(allNetworks)
        _performRandomUpdate()
    }

    var scanForNetworks = true
    var wifiEnabled = true
    var availableNetworks: Set<Network> {
        _availableNetworks
    }
    
    // MARK: - Privates
    private var _availableNetworks = Set<Network>()
    private var updateInterval = 2000
    
    private func _performRandomUpdate() {
        if wifiEnabled && scanForNetworks {
            var updatedNetworks = Array(_availableNetworks)
            
            if updatedNetworks.isEmpty {
                _availableNetworks = Set<Network>(allNetworks)
            } else {
                let shouldRemove = Int.random(in: 0..<3) == 0
                if shouldRemove {
                    let removeCount = Int.random(in: 0..<updatedNetworks.count)
                    for _ in 0..<removeCount {
                        let removeIndex = Int.random(in: 0..<updatedNetworks.count)
                        updatedNetworks.remove(at: removeIndex)
                    }
                }
                
                let shouldAdd = Int.random(in: 0..<3) == 0
                if shouldAdd {
                    let allNetworksSet = Set<Network>(allNetworks)
                    var updatedNetworksSet = Set<Network>(updatedNetworks)
                    let notPresentNetworksSet = allNetworksSet.subtracting(updatedNetworksSet)
                    
                    if !notPresentNetworksSet.isEmpty {
                        let addCount = Int.random(in: 0..<notPresentNetworksSet.count)
                        var notPresentNetworks = [Network](notPresentNetworksSet)
                        for _ in 0..<addCount {
                            let removeIndex = Int.random(in: 0..<notPresentNetworks.count)
                            let networkToAdd = notPresentNetworks[removeIndex]
                            notPresentNetworks.remove(at: removeIndex)
                            updatedNetworksSet.insert(networkToAdd)
                        }
                    }
                    updatedNetworks = [Network](updatedNetworksSet)
                }
                updateAvailableNetworks(updatedNetworks)
            }
            
            // notify
            updateHandler(self)
        }
        
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(updateInterval)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self._performRandomUpdate()
        }
    }
    
    func updateAvailableNetworks(_ networks: [Network]) {
        _availableNetworks = Set<Network>(networks)
    }

    private let allNetworks = [ Network(name: "AirSpace1"),
                                Network(name: "Living Room"),
                                Network(name: "Courage"),
                                Network(name: "Nacho WiFi"),
                                Network(name: "FBI Surveillance Van"),
                                Network(name: "Peacock-Swagger"),
                                Network(name: "GingerGymnist"),
                                Network(name: "Second Floor"),
                                Network(name: "Evergreen"),
                                Network(name: "__hidden_in_plain__sight__"),
                                Network(name: "MarketingDropBox"),
                                Network(name: "HamiltonVille"),
                                Network(name: "404NotFound"),
                                Network(name: "SNAGVille"),
                                Network(name: "Overland101"),
                                Network(name: "TheRoomWiFi"),
                                Network(name: "PrivateSpace")
    ]

}
