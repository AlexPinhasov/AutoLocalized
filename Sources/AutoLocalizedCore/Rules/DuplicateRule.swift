//
//  File 2.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct DuplicateRule: Rule {
    public var name: String = "duplicateKey"
    public var description: String = "Search for duplicate keys in a localization file"
    public var row: Row
    public var errorString: String {
        "🔑 \"%@\" has a duplicate in line %@.".withArguments([row.key, row.number.description])
    }
}
