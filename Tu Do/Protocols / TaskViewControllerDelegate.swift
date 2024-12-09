//
//  TaskViewControllerDelegate.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 27/11/2024.
//

import Foundation

protocol  NewTaskViewControllerDelegate {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}
