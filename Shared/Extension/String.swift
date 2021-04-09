//
//  String.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 14.03.2021.
//

import Foundation

extension String {
    var withoutTags: String {
        let regex = try! NSRegularExpression(pattern: "\u{1B}(?:[@-Z\\-_]|\\[[0-?]*[ -/]*[@-~])")
        let range = NSRange(startIndex ..< endIndex, in: self)

        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
    var newsDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter.date(from: self) ?? Date()
    }
}
