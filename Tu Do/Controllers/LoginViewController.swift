//
//  LoginViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 09/12/2024.
//

import UIKit
class LoginViewController:UIViewController ,Animatable{
    //MARK: outlets
    @IBOutlet weak var loginButton:UIButton!
    
    //MARK: delegate
    weak var delegate:LoginViewControllerDelegate?
    //MARK: properties
    let authManager = AuthManager()
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Actions

    @IBAction func loginButtonTapped(_ sender: Any) {
        showLoadingAnimation()
        authManager.login(withEmail: "ahmed@gmail.com", password: "123456") { [weak self](result) in
            self?.hideLoadingAnimation()
            switch result {
                
            case .success():
                self?.delegate?.didlogin()
            case .failure(_):
                self?.displayMessage(state: .error, massage: "UserName or Password Are wrong")
            }
        }
     
    }
    //MARK: Properties
}
extension LoginViewController {
    func configureUI() {
    }
}

