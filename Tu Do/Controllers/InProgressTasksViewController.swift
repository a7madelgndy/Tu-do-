//
//  inProgressTasksViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit

protocol InProgressTasksVCDelete: AnyObject{
    func showOptionsForTask(task: Task)
}

class InProgressTasksViewController: UITableViewController ,Animatable{
    //MARK: propertis
    private var databaseManger = DatabaseManager()
    private var tasks:[Task] = []{
        didSet{
            tableView.reloadData()
        }
    }
    weak var delegate:InProgressTasksVCDelete?
    private let authManager = AuthManager()
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addTasklistener()
    }
    
    //MARK: helpers methods
    private func addTasklistener(){
        guard let uid = authManager.getUserId() else{
            print("there is no user ")
            return}
        databaseManger.addlistener(forDoneTask: false, uid: uid) { [weak self ](result)in
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
                self?.displayMessage(state: .info,massage: MessageState.success.rawValue, location: .top )
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
        let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdenifer.inprogressCell.rawValue,for: indexPath) as? InProgressTableViewCell
        let task = tasks[indexPath.row]
        cell?.configurerCell(task:task )

        cell?.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(as: task)
        }
        return cell ?? UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        delegate?.showOptionsForTask(task: task)
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
