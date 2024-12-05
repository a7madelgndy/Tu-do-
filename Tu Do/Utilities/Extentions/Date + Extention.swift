//
//  Date + Extention.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import Foundation

extension Date {
    func convertToString()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d,yyy"
        return formatter.string(from: self)
    }
}
