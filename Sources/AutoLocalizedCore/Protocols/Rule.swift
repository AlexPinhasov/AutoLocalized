//
//  Rule.swift
//  
//
//  Created by Alex Pinhasov on 31/08/2020.
//

public protocol Rule {
    /// Rule name
    var name: String { get set }

    /// Row effected by this rule
    var row: Row { get set }

    // Rule description
    var description: String { get set }

    /// Rule output string
    var errorString: String { get }
}
