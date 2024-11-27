//
//  ViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit

class TasksViewController: UIViewController {
    //MARK: outlets
    @IBOutlet var menuSegmentedControll: UISegmentedControl!
    @IBOutlet var inProgressTasksContianerView : UIView!
    @IBOutlet var DoneTasksContianerView : UIView!
    
    //MARK: properties
    private var databaseManager = DatabaseManager()

    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpmenuSegmentedControll()
        showContainerView(for: .inProgress)
    }
    
    //MARK: actions
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddNewTask" ,
           let destination = segue.destination as? NewTaskViewController{
            destination.delegate = self
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

extension TasksViewController: TaskViewControllerDelegate {
    func didAddTask(_ task: Task) {
    databaseManager.addNewTask(task) { (result) in
            switch result{
                
            case .success():
                print("new task was added")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
