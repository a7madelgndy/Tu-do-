//
//  Animatable.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 27/11/2024.
//

import Loaf
import Foundation

protocol Animatable {
    
}

extension Animatable where Self:UIViewController{
    func displayMessage(state: Loaf.State ,massage:String ,location : Loaf.Location = .top ,duration : TimeInterval = 0.8){
        DispatchQueue.main.async {
            Loaf(massage, state: state, location: location,
                 sender: self).show()}
        
    }
}
