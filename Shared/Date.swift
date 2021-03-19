//
//  Date.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 16.03.2021.
//

import Foundation

extension Date {
    var logDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
    
    var siteDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

extension TimeInterval {
    var convertedDeployTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full

        return formatter.string(from: self) ?? ""
    }
}
