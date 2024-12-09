//
//  NavigationManager.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 09/12/2024.
//

import UIKit

class NavigationManager {
    
    static let shared = NavigationManager()
    private init(){
        
    }
    enum Scene {
        case onboaring
        case tasks
    }
    
    func show(scene: Scene) {
        var controller : UIViewController
        switch scene {
        case .onboaring:
            controller = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "OnboardingControllerView")
        case .tasks:
            controller = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TaskViewController")
  
        }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene ,
              let sceneDelegate = windowScene.delegate as? SceneDelegate ,
              let widnow  = sceneDelegate.window  else {return}
        widnow.rootViewController = controller
        UIView.transition(with:widnow , duration: 0.5, options: .curveEaseInOut, animations:{}, completion: nil)
    }
}
