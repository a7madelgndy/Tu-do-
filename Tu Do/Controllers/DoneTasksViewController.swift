//
//  DoneTasksViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit
class DoneTasksViewController: UITableViewController,Animatable{
    //MARK: properties
    private var databaseManger = DatabaseManager()
    private var tasks:[Task] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private let authManager = AuthManager()
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addTasklistener()
    }
   //MARK: actions
    @IBAction func handleActionButtonTapped(_ sender : UIButton){
        
    }
    //MARK: helpers
    private func addTasklistener(){
        guard let uid = authManager.getUserId() else {
            print("there is no user")
            return }
        databaseManger.addlistener(forDoneTask: true, uid: uid) { [weak self ](result)in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                print(tasks.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func handleActionButtonTapped(as task : Task){
        guard let taskId = task.id else {return}
        databaseManger.toggleTaskCompletionStatus(id: taskId, moveTo: .inProgress) { [weak self]   (result) in
            switch result {
            case .success:
                self?.displayMessage(state: .info,massage: MessageState.inProgress.rawValue , location: .top )
            case .failure(let error):
                self?.displayMessage(state: .error,massage: error.localizedDescription, location: .top )
            }
        }
    }

}

extension DoneTasksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdenifer.DoneCell.rawValue ,for: indexPath) as? DoneTasksTableViewCell
        let task = tasks[indexPath.row]
        cell?.configurerCell(task:task )
        
        cell?.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(as: task)
        }
        return cell ?? UITableViewCell()
    }
}
