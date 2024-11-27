//
//  inProgressTasksViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit
import Loaf
class InProgressTasksViewController: UITableViewController ,Animatable{
    //MARK: propertis
    private var databaseManger = DatabaseManager()
    private var tasks:[Task] = []{
        didSet{
            tableView.reloadData()
        }
    }
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addTasklistener()
    }
    //MARK: helpers methods
    private func addTasklistener(){
        databaseManger.addlistener(forDoneTask: false) { [weak self ](result)in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
   //MARK: actions
    private func handleActionButtonTapped(as task : Task){
        guard let taskId = task.id else {return}
        databaseManger.toggleTaskCompletionStatus(id: taskId, moveTo: .done) { [weak self]   (result) in
            switch result {
            case .success:
                self?.displayMessage(state: .info,massage: "Move TO Done", location: .top )
            case .failure(let error):
                self?.displayMessage(state: .error,massage: error.localizedDescription, location: .top )
            }
        }
    }
}
extension InProgressTasksViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellid" ,for: indexPath) as? InProgressTableViewCell
        let task = tasks[indexPath.row]
        cell?.configurerCell(task:task )

        cell?.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(as: task)
        }
        return cell ?? UITableViewCell()
    }
}
