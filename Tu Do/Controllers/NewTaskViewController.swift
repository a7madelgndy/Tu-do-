//
//  NewTaskViewController].swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit
import Combine

class NewTaskViewController:UIViewController {
    //MARK: Properties(Outlets)
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewBottonConstrain: NSLayoutConstraint!
    @IBOutlet var newTaskTextFiled: UITextField!
    @IBOutlet var saveButton:UIButton!
    
    //MARK: Properties
    private var subscriper = Set <AnyCancellable>()
    @Published private var textFiledString:String?
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        observeTextFiled()
        setupGesture()
        observeKeyboard()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newTaskTextFiled.becomeFirstResponder()
    }
    //MARK: Selectors
    @objc func dismissViewController(){
        dismiss(animated: true)
    }

    @objc private func keyboardwillAppear(_ notification: Notification){
        let keyboardHight = getKeyboardHight(notification: notification)
        containerViewBottonConstrain.constant = keyboardHight - (200+8)
    }
    //MARK: Actions
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    //MARK: helper
    private func observeTextFiled(){
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).map { (notification)-> String? in
            return (notification.object as! UITextField).text
        }.sink{ [weak self] (text) in
            self?.textFiledString = text
        }.store(in: &subscriper)
        
        $textFiledString.sink { [weak self] text in
            self?.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscriper)
    }

}

//MARK: setUp view
extension NewTaskViewController {
    private func setUpBackground() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottonConstrain.constant = -containerView.frame.height
    }
    private func setupGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: handel keyboard Hight
extension NewTaskViewController {
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillAppear(_: )), name:UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func getKeyboardHight(notification: Notification) -> CGFloat {
        guard let keyboardhight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }
        return keyboardhight
    }
}

