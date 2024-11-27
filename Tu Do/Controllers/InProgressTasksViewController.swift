//
//  inProgressTasksViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit

class InProgressTasksViewController: UITableViewController {
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
   
    private func handleActionButtonTapped(as task : Task){
        guard let taskId = task.id else {return}
        databaseManger.updateTaskToDone(id: taskId) { (result) in
            switch result {
            case .success:
                print("task added to done")
            case .failure(let error):
                print(error.localizedDescription)
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
