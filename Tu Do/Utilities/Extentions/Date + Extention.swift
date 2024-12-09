//
//  Date + Extention.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import Foundation

extension Date {
    func convcertToString()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d,yyy"
        return formatter.string(from: self)
    }
    
    func toRelativeDate()->String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let today = Date()
        return formatter.localizedString(for: self, relativeTo: today)
    }
    
    func isOverDue() -> Bool {
        let today = Date()
        return self < today
    }
}
