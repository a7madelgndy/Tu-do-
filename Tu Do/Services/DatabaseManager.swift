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
        listener = taskCollection.whereField("isDone", isEqualTo: isDone).order(by: "createdAt", descending: true)
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
    func toggleTaskCompletionStatus(id:String , moveTo section : MenuSections , complation: @escaping(Result<Void,Error>)-> Void) {
        //MARK: Broke single resposiblity please fix it
        var field: [String : Any]  = [:]
        switch section {
            case .inProgress: 
             field = ["isDone":false ,"doneAt" : Date()]

            case .done:
            field = ["isDone":true ,"doneAt" : FieldValue.description()]

                
        }
        taskCollection.document(id).updateData(field){(error) in
            if let error {
                complation(.failure(error))
            }else{
                complation(.success(()))
            }
        }
    }
}

