//
//  String+Extensions.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Foundation

extension String {
    func splitInTwoParts() -> [String] {
        let words = self.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        let halfCount = (words.count + 1) / 2
        let firstPart = words.prefix(halfCount).joined(separator: " ")
        let secondPart = words.suffix(words.count - halfCount).joined(separator: " ")

        return [firstPart, secondPart]
    }
}
