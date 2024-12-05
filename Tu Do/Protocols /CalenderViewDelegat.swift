//
//  CalenderViewDelegat.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import Foundation
protocol CalenderViewDelegat : AnyObject {
    func deadLineDidSelected(date: Date)
    func ResetButtonTapped()
}
