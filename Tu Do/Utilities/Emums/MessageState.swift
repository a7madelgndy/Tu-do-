//
//  MessageState.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import Foundation

enum MessageState: String {
    case success = "Task Completed Successfully"
    case error = "An Error Occurred"
    case delete = "Task Deleted Successfully"
    case inProgress = "Add Task to In Progress"
    case pending = "Task is Pending"
}
