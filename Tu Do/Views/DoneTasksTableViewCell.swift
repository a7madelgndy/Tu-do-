//
//  DoneTasksTableViewCell.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 27/11/2024.
//

import UIKit

class DoneTasksTableViewCell:UITableViewCell {
    
    //MARK: outlets
    @IBOutlet weak var taskTitleLableL:UILabel!
    
    var actionButtonDidTap:(()->Void)?

    @IBAction func doneButtonTapped(_ sender: UIButton){
        actionButtonDidTap?()
    }
    //MARK: helpers
    func configurerCell(task : Task){
        taskTitleLableL.text = task.taskTitle
    }
}
