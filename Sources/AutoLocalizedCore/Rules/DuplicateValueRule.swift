//
//  DuplicateValueRule.swift
//  
//
//  Created by Alex Pinhasov on 10/09/2020.
//

import Foundation

public struct DuplicateValueRule: Rule {
    public var name: String = "duplicateValue"
    public var description: String = "Search for duplicate values in a localization file"
    public var row: Row
    public var errorString: String {
        "✏️ \"%@\" has the value in line %@.".withArguments([row.value, row.number.description])
    }
}
