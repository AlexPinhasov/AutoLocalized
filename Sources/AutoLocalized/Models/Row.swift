//
//  File 2.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

class Row: Hashable {
    var number: Int
    private(set) var key: String
    private(set) var value: String
    private(set) var file: File?

    var keyValue: String {
        "\"\(key)\" = \"\(value)\";"
    }

    init(in file: File, number: Int, key: String, value: String) {
        self.file = file
        self.number = number
        self.key = key
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }

    static func == (lhs: Row, rhs: Row) -> Bool {
        return lhs.key == rhs.key
    }
}
