//
//  AuthManager.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 09/12/2024.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    let auth = Auth.auth()
    func login(withEmail email:String, password:String,completion: @escaping (Result<Void,Error>)->Void){
        auth.signIn(withEmail: email, password: password) { (result , error) in
            if let error {
                completion(.failure(error))
            }else  {
                completion(.success(()))
            }
        }
    }
    func logout(completion: @escaping (Result<Void,Error>)->Void) {
        do{
            try auth.signOut()
            completion(.success(()))
        }catch(let error ) {
            completion(.failure(error))
        }

    }
}
