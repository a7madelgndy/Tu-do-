//
//  InProgressTableViewCell.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 27/11/2024.
//

import UIKit

class InProgressTableViewCell:UITableViewCell {
    //MARK: properties
    @IBOutlet weak var titleLable:UILabel!
    @IBOutlet weak var deadlineLable:UILabel!
    var actionButtonDidTap:(()->Void)?
    
    //MARK: actions
    
    @IBAction func doneButtonTapped(_ sender: UIButton){
        actionButtonDidTap?()
    }
    //MARK: helpers
    
    func configurerCell(task: Task){
        titleLable.text = task.taskTitle
        deadlineLable.text = task.deadline?.toRelativeDate()
        if(task.deadline?.isOverDue() == true) {
            deadlineLable.textColor = .systemRed
        }
    }
    
} 
