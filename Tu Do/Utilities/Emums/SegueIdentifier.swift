//
//  SegueIdentifier.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import Foundation
enum SegueIdentifier: String {
    case showAddNewTask = "ShowAddNewTask"
    case inProgressTasks = "inProgressTasks"
    var ID: String {
        return self.rawValue
    }
}
