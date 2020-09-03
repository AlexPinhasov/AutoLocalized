//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 29/08/2020.
//

import Foundation

extension Array where Element: Comparable {
    func isAscending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(<=)
    }

    func isDescending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(>=)
    }
}
