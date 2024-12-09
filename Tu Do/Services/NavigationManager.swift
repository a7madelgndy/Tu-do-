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
        switch scene {
        case .onboaring:break
        case .tasks:
            let naviagationController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TaskViewController")
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene ,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate ,
                  let widnow  = sceneDelegate.window  else {return}
            widnow.rootViewController = naviagationController
            UIView.transition(with:widnow , duration: 0.5, options: .curveEaseInOut, animations:{}, completion: nil)
        }
    }
}
