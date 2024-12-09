//
//  NewTaskViewController].swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 26/11/2024.
//

import UIKit
import Combine

class NewTaskViewController:UIViewController {
    //MARK: Properties
    //MARK: -Outlets
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewBottonConstrain: NSLayoutConstraint!
    @IBOutlet var taskTextFiled: UITextField!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var dealLineLabel: UILabel!
    
    //MARK: -To abserve
    private var subscriper = Set <AnyCancellable>()
    @Published private var textFiledString:String?
    @Published private var deadline:Date?
    
    //MARK: -Variables
    private var keyboardHight:CGFloat?
    var taskToEdit:Task?
    
    //MARK: - delegats
    var delegate:NewTaskViewControllerDelegate?
    
    //MARK: - Views
    lazy private var calendarView:CalendarView = {
        let view = CalendarView()
        view.delegat = self
        return view
    }()
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
        taskTextFiled.becomeFirstResponder()
    }
    //MARK: Selectors
    @objc func dismissViewController(){
        dismiss(animated: true)
    }

 
    //MARK: Actions
    @IBAction func calendarButtonTapped(_ sender: Any) {
        taskTextFiled.resignFirstResponder()
        containerViewBottonConstrain.constant = -self.keyboardHight! - (200+8)
        showCalendar()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let text = self.textFiledString else {return }
        var task = Task(taskTitle: text , deadline: deadline)
        if let id = taskToEdit?.id {
            task.id = id
        }
        if taskToEdit == nil {
            delegate?.didAddTask(task)
        }else  {
            delegate?.didEditTask(task)
        }
        dismiss(animated: true)
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
        
        $deadline.sink {  date in
            self.dealLineLabel.text = date?.convcertToString() ?? " "
        }.store(in: &subscriper)
    }
    
    func dismissCalendarView(completion:() -> Void){
        calendarView.removeFromSuperview()
        completion()
    }
    

}

//MARK: setUp view
extension NewTaskViewController {
    private func setUpBackground() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottonConstrain.constant = -containerView.frame.height
        if let taskToEdit {
            taskTextFiled.text = taskToEdit.taskTitle
            deadline = taskToEdit.deadline
            saveButton.setTitle("Update", for: .normal)
            calendarView.selectData(date: taskToEdit.deadline)
        }
    }
    
    
    private func setupGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: Tap Gesture
extension NewTaskViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let isTextFirstResponer = self.taskTextFiled.isFirstResponder
        let touchLocation = touch.location(in: view)
        
        if !calendarView.frame.contains(touchLocation) && !isTextFirstResponer {
            dismissCalendarView { [unowned self] in
                self.taskTextFiled.becomeFirstResponder()
            }
         
            return false
        } else if isTextFirstResponer {
            return true
        } else if !isTextFirstResponer && calendarView.frame.contains(touchLocation)  {
            return false
        }
        return true
    }
}
//MARK: handel keyboard Hight
extension NewTaskViewController {
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillAppear(_: )), name:UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc private func keyboardwillAppear(_ notification: Notification){
        self.keyboardHight = getKeyboardHight(notification: notification)
        containerViewBottonConstrain.constant = self.keyboardHight! - (200 + 8)
    }

    private func getKeyboardHight(notification: Notification) -> CGFloat {
        guard let keyboardhight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }
        return keyboardhight
    }

}

// MARK:Calendar
extension NewTaskViewController {
    private func showCalendar(){
        view.addSubview(calendarView)
        calendarView.setConstrains(
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingBottom: 20,
            height: 300)
    }
    
}

extension NewTaskViewController: CalenderViewDelegat {
    func ResetButtonTapped() {
        dismissCalendarView { [unowned self] in
            self.taskTextFiled.becomeFirstResponder()
            self.dealLineLabel = nil
        }
    }
    
    func deadLineDidSelected(date: Date) {
        dismissCalendarView { [unowned self] in
            self.deadline = date
            self.taskTextFiled.becomeFirstResponder()
        }
    }
    
    
}
