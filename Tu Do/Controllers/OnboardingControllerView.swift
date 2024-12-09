//
//  OnboardingControllerView.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 09/12/2024.
//

import UIKit
class OnboardingControllerView:UIViewController{
    //MARK: Properties
    @IBOutlet var getStartedBtn: UIButton!
    
    private let navigationManager = NavigationManager.shared
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Actions
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showloginScreen", sender: nil)
    }
   
    //MARK:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showloginScreen" ,
           let destination = segue.destination as? LoginViewController {
            destination.delegate = self
        }
    }
}
extension OnboardingControllerView {
    func configureUI() {
        getStartedBtn.layer.cornerRadius = 15
    }
}
extension OnboardingControllerView:LoginViewControllerDelegate {
    func didlogin() {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.navigationManager.show(scene: .tasks)
        })
    }
    
    
    
}
