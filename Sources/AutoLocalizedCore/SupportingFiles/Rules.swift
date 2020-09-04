//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 04/09/2020.
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

public struct DeadRule: Rule {
    public var name: String = "deadKey"
    public var description: String = "Search for unused keys in localization files"
    public var row: Row
    public var errorString: String {
         "Dead 🔑 \"%@\", not being used.".withArguments([row.key])
    }
}

public struct MissingRule: Rule {
    public var name: String = "missingKey"
    public var description: String = "Search for missing keys in localization files found in project files"
    public var row: Row
    public var errorString: String {
         "🔑 \"%@\" is missing from localization files.".withArguments([row.key])
    }
}

public struct MatchRule: Rule {
    public var name: String = "localizeFilesDontMatch"
    public var description: String = "Make sure localization files keys match"
    public var row: Row
    public var errorString: String {
        "🔑 \"%@\" appears in other localization files but is missing here.".withArguments([row.key])
    }
}
