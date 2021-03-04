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

    init() {
        updateAvailableNetworks(allNetworks)
    }

    var availableNetworks: Set<Network> {
        _availableNetworks
    }
    
    // MARK: - Privates
    private var _availableNetworks = Set<Network>()
    
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
