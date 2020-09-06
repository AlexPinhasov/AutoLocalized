//
//  File 3.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct DeadRule: Rule {
    public var name: String = "deadKey"
    public var description: String = "Search for unused keys in localization files"
    public var row: Row
    public var errorString: String {
         "Dead 🔑 \"%@\", not being used.".withArguments([row.key])
    }
}
