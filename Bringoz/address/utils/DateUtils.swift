//
//  DateUtils.swift
//  Bringoz
//
//  Created by Sandip Soni on 06/01/22.
//

import Foundation

class DateUtils{
    
    static var shared = DateUtils()
    
    func formatDateToString(dateTime date: Date,isDate: Bool) -> String {
        let formatter = DateFormatter.init()
        formatter.dateStyle = isDate ? .medium : .none
        formatter.timeStyle = isDate ? .none : .short
        return formatter.string(from: date)
    }
}



