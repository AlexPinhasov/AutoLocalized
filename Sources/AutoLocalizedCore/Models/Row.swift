//
//  Row.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

public class Row: Hashable {
    private(set) var number: Int
    private(set) var key: String
    private(set) var value: String
    private(set) var file: File?

    /// Return a key value row for .strings file
    var keyValue: String {
        "\"\(key)\" = \"\(value)\";"
    }

    func setNewRowNumber(_ number: Int) {
        self.number = number
    }

    init(in file: File, number: Int, key: String, value: String) {
        self.file = file
        self.number = number
        self.key = key
        self.value = value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }

    static public func == (lhs: Row, rhs: Row) -> Bool {
        return lhs.key == rhs.key
    }
}
