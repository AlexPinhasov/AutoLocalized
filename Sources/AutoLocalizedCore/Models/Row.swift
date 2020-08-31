//
//  File 2.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

public class Row: Hashable {
    var number: Int
    public private(set) var key: String
    public private(set) var value: String
    public private(set) var file: File?

    var keyValue: String {
        "\"\(key)\" = \"\(value)\";"
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
