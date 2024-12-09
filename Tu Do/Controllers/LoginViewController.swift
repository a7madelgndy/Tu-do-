//
//  LoginViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 09/12/2024.
//

import UIKit
class LoginViewController:UIViewController{
    //MARK: Properties
    @IBOutlet weak var loginButton:UIButton!
    
    //MARK: delegate
    weak var delegate:LoginViewControllerDelegate?
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Actions

    @IBAction func loginButtonTapped(_ sender: Any) {
        delegate?.didlogin()
    }
    //MARK: Properties
}
extension LoginViewController {
    func configureUI() {
     print("hi")
    }
}

