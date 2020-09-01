//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 31/08/2020.
//

public protocol Rule {
    var name: String { get set }
    var row: Row { get set }
    var description: String { get set }
    var errorString: String { get set }
}

public final class DuplicateRule: Rule {
    public var name: String = "duplicateKey"
    public var description: String = "Search for duplicate keys in a localization file"
    public var row: Row
    public lazy var errorString: String = "🔑 \"%@\" has a duplicate in line %@.".withArguments([row.key, row.number.description])

    init(forRow row: Row) {
        self.row = row
    }
}

public final class DeadRule: Rule {
    public var name: String = "deadKey"
    public var description: String = "Search for unused keys in localization files"
    public var row: Row
    public lazy var errorString: String = "Dead 🔑 \"%@\", not being used.".withArguments([row.key])

    init(forRow row: Row) {
        self.row = row
    }
}

public final class MissingRule: Rule {
    public var name: String = "missingKey"
    public var description: String = "Search for missing keys in localization files found in project files"
    public var row: Row
    public lazy var errorString: String = "🔑 \"%@\" is missing in strings files.".withArguments([row.key])

    init(forRow row: Row) {
        self.row = row
    }
}

public final class MatchRule: Rule {
    public var name: String = "localizeFilesDontMatch"
    public var description: String = "Make sure localization files keys match"
    public var row: Row
    public lazy var errorString: String = "🔑 \"%@\" appears in other localization files but is missing here.".withArguments([row.key])

    init(forRow row: Row) {
        self.row = row
    }
}
