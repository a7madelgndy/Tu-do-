//
//  VCIdentifier.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import Foundation

enum VCIdentifier: String {
    case home = "HomeViewController"
    case details = "DetailsViewController"
    case settings = "SettingsViewController"
    case profile = "ProfileViewController"
    
    var storyboardID: String {
        return self.rawValue
    }
}
