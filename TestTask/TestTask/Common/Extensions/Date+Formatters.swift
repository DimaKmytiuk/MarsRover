//
//  Date+Formatters.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Foundation

extension Date {
    func string(formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    
    static func changeDate(date: String) -> String {
        let inputDateString = date
        let inputDateFormatter = DateFormatter.customDateWithDashFormatter
        
        if let inputDate = inputDateFormatter.date(from: inputDateString) {
            let outputString = inputDate.string(formatter: .customFormattedStringDateFormatter)
            
            return outputString
        } else {
            return ""
        }
    }
}

extension DateFormatter {
    
    static var customFormattedStringDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
    
    static var customDateWithDashFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter
    }

}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}
