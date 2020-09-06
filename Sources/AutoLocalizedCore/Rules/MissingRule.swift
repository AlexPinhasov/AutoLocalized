//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct MissingRule: Rule {
    public var name: String = "missingKey"
    public var description: String = "Search for missing keys in localization files found in project files"
    public var row: Row
    public var errorString: String {
         "🔑 \"%@\" is missing from localization files.".withArguments([row.key])
    }
}
