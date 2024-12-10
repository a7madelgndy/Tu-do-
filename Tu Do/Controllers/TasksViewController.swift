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
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
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
    
    @IBAction func menuButtonTapped(_ sender: Any) {
       showMenuOptions()
    }

    @IBAction func AddTaskButtonTapped(_ sender : UIButton){
        performSegue(withIdentifier: SegueIdentifier.showAddNewTask.ID, sender: nil)
    }
    
    //MARK: Prepare for a segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showAddNewTask.ID,
           let destination = segue.destination as? NewTaskViewController{
            destination.delegate = self
        }else if segue.identifier == SegueIdentifier.inProgressTasks.ID ,
                 let destination = segue.destination as? InProgressTasksViewController{
            destination.delegate = self
        }else if segue.identifier == SegueIdentifier.showediteTask.ID ,
                 let destination =  segue.destination  as? NewTaskViewController  , let taskToEdit = sender as? Task{
            destination.delegate = self
            destination.taskToEdit =  taskToEdit
        }
    }
}

//MARK: Helpers
extension TasksViewController {
    func logoutUser() {
        authManager.logout { [unowned self ](result)in
            switch result {
            case .success():
                navigationManager.show(scene: .onboaring)
                
            case .failure(let error):
                displayMessage(state: .error, massage: error.localizedDescription)
            }
        }
    }
    func showMenuOptions() {
        let alertController = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel)
        let logoutAction = UIAlertAction(title: "Logout", style:.default) {[unowned self] _ in
            self.logoutUser()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        present(alertController, animated: true,completion: nil)
    }
}
//MARK: Managing Alert Controller
extension TasksViewController:InProgressTasksVCDelete {
    func showOptionsForTask(task: Task){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: TaskAction.cancel.rawValue, style: .cancel)
        let editAction = UIAlertAction(title: TaskAction.edit.rawValue, style: .default) {[unowned self] _ in
            self.editTask(task: task )
        }
        let DeleteAction = UIAlertAction(title: TaskAction.delete.rawValue, style: .destructive) {[unowned self] _ in
            self.deleteTask(taskId: task.id ?? "0")
        }
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        alertController.addAction(DeleteAction)
        present(alertController, animated: true)
    }
}

//MARK: Managing SegmentedControll
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

//MARK: ADD a task
extension TasksViewController:  NewTaskViewControllerDelegate {
    func didEditTask(_ task: Task) {
        presentedViewController?.dismiss(animated: true, completion: {
            guard let id = task.id else {return }
            self.databaseManager.editTask(id: id , title: task.taskTitle, deadline:task.deadline) { (result) in
                switch result{
                case .success():
                    self.displayMessage(state: .success, massage: MessageState.updated.rawValue)
                case .failure(let error):
                    self.displayMessage(state: .error, massage: error.localizedDescription, location: .top)           
                }
                
            }
        })
    }
    
    func didAddTask(_ task: Task) {
    presentedViewController?.dismiss(animated: true, completion: {
            self.databaseManager.addNewTask(task) { [weak self] (result) in
            switch result{
            case .success():
                break
            case .failure(let error):
                self?.displayMessage(state: .error, massage: error.localizedDescription, location: .top)            }
        }
    })}}

//MARK: task Deletion
extension TasksViewController: Animatable {
    func deleteTask(taskId: String){
        databaseManager.deleteTask(taskId: taskId) { [weak self](result) in
            switch result {
            case .success():
                self?.displayMessage(state:.success, massage: MessageState.delete.rawValue)
            case .failure(let error):
                self?.displayMessage(state:.error, massage: error.localizedDescription )
            }
            
        }
    }
}

//MARK: task edition
extension TasksViewController {
    func editTask(task: Task ){
        performSegue(withIdentifier: "showEditTask", sender:task)
    }

}
