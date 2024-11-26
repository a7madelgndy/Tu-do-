//
//  ViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet var menuSegmentedControll: UISegmentedControl!
    @IBOutlet var inProgressTasksContianerView : UIView!
    @IBOutlet var DoneTasksContianerView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpmenuSegmentedControll()
        showContainerView(for: .inProgress)
    }
    
    @IBAction func SegmentedControllTapped(_ sender : UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0 :
            showContainerView(for: .inProgress)
        case 1 :
            showContainerView(for: .done)
        default :
            break
        }
    }
    @IBAction func AddTaskButtonTapped(_ sender : UIButton){
        performSegue(withIdentifier: "ShowAddNewTask", sender: nil)
    }
}

//MARK: Managing SegmentedControll part
extension TasksViewController {
    private func setUpmenuSegmentedControll(){
        menuSegmentedControll.removeAllSegments()
        MenuSections.allCases.enumerated().forEach { ( index ,section ) in
            menuSegmentedControll.insertSegment(withTitle: section.rawValue, at: index, animated: true)
        }
        menuSegmentedControll.selectedSegmentIndex = 0
    }
    
    private func showContainerView(for section : MenuSections ) {
        switch section {
        case .inProgress:
            inProgressTasksContianerView.isHidden = false
            DoneTasksContianerView.isHidden = true
        case .done:
            inProgressTasksContianerView.isHidden = true
            DoneTasksContianerView.isHidden = false
        }
    }
}
