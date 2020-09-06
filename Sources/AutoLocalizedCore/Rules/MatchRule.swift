//
//  File 4.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct MatchRule: Rule {
    public var name: String = "localizeFilesDontMatch"
    public var description: String = "Make sure localization files keys match"
    public var row: Row
    public var errorString: String {
        "🔑 \"%@\" appears in other localization files but is missing here.".withArguments([row.key])
    }
}
