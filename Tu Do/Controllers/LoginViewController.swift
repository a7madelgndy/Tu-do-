//
//  LoginViewController.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 09/12/2024.
//

import UIKit
import Combine
//"ahmed@gmail.com"
//"123456"
class LoginViewController:UIViewController ,Animatable{
    //MARK: outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var singupButton: UIButton!
    @IBOutlet weak var errorLabel:UILabel!
    //MARK: To observe
    private var subscribers = Set<AnyCancellable>()
    @Published var errorString: String = " "
    //MARK: delegate
    weak var delegate:LoginViewControllerDelegate?
    //MARK: properties
    let authManager = AuthManager()
    //MARK: lifecycles
    override func viewDidLoad() {
        observeForm()
        configureUi()
        super.viewDidLoad()
    }
    //MARK: Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text , !email.isEmpty ,
              let password = passwordTextField.text , !password.isEmpty else {
            errorString = "Incomplet Form "
            return
        }
        showLoadingAnimation()
        authManager.login(withEmail:email, password: password) { [weak self](result) in
            self?.hideLoadingAnimation()
            switch result {
                
            case .success():
                self?.delegate?.didlogin()
            case .failure(_):
                self?.displayMessage(state: .error, massage: "UserName or Password Are wrong")
            }
        }
     
    }
    
    @IBAction func singUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text , !email.isEmpty ,
              let password = passwordTextField.text , !password.isEmpty else {
            errorString = "Incomplet Form "
            return
        }
        showLoadingAnimation()
        authManager.signUp(withEmail: email, password: password) {[weak self](result) in
            self?.hideLoadingAnimation()
            switch result {
                
            case .success():
                self?.delegate?.didlogin()
            case .failure(let error):
                self?.displayMessage(state: .error, massage: error.localizedDescription)
            }
        }
    }
    //MARK: Helbers
    func observeForm() {
        $errorString.sink { [unowned self
        ](errorMassage) in
            self.errorLabel.text = errorMassage
        }.store(in: &subscribers)
    }
}
extension LoginViewController {
    func configureUi() {
        for view in [loginButton , singupButton] {
            view?.layer.cornerRadius = 10
        }
        singupButton.backgroundColor = .white
        singupButton.setTitleColor(.systemBlue, for: .normal)
        singupButton.layer.borderColor = UIColor(named: Colors.C64A4F8.rawValue)?.cgColor
        singupButton.layer.borderWidth = 1
    }

}

