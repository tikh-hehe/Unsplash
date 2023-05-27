//
//  String+Ext.swift
//  Unsplash
//
//  Created by tikh on 17.05.2023.
//

import Foundation

extension String {
    
    func convertToDayMonthYear() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = inputFormatter.date(from: self)

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, MMM d, yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        let outputString = outputFormatter.string(from: date!)

        return outputString
    }
}
