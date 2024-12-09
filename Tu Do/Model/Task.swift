//
//  Task.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 27/11/2024.
//

import Foundation
import FirebaseFirestore

struct Task: Identifiable ,Codable {
   @DocumentID var id:String?
   @ServerTimestamp var createdAt:Date?
   var taskTitle:String
    var isDone : Bool = false
    var doneAT: Date?
    var deadline: Date?
    var uId : String?
}
