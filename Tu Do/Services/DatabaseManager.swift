//
//  DatabaseManager.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 27/11/2024.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    //MARK: Properties
    private let db = Firestore.firestore()
    private lazy var taskCollection = db.collection("tasks")
    private var listener :ListenerRegistration?
    
    //MARK: Methouds
    func addNewTask(_ task: Task,  complation:@escaping(Result<Void,Error>) -> Void){
        do{
            _ = try taskCollection.addDocument(from:task, completion: {(error) in
                if let error  {
                    complation(.failure(error))
                }else {
                    complation(.success(()))
                }
            }
            )
        }catch(let error){
            complation(.failure(error))
        }
    }

    func addlistener(forDoneTask isDone:Bool ,completion: @escaping (Result<[Task] ,Error>)-> Void) {
        listener = taskCollection.whereField("isDone", isEqualTo: false).order(by: "createdAt", descending: true)
            .addSnapshotListener({ (snapshot , erorr) in
            if let erorr {
                completion(.failure(erorr))
            }else {
                var tasks = [Task]()
                do {
                    for document in snapshot?.documents ?? [] {
                        let task = try document.data(as: Task.self)
                        tasks.append(task)
                    }
                    completion(.success(tasks))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        )
    }
    func updateTaskToDone(id:String , complation: @escaping(Result<Void,Error>)-> Void) {
        let field: [String : Any] = ["isDone":true ,"doneAt" : Date()]
        taskCollection.document(id).updateData(field){(error) in
            if let error {
                complation(.failure(error))
            }else{
                complation(.success(()))
            }
        }
    }
}

