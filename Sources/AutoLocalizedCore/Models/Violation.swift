//
//  Violation.swift
//  
//
//  Created by Alex Pinhasov on 31/08/2020.
//

public enum Violation {
    case error(Rule), warning(Rule)

    var rawValue: String {
        switch self {
        case .error: return "error"
        case .warning: return "warning"
        }
    }

    var rule: Rule {
        switch self {
        case .error(let rule), .warning(let rule): return rule
        }
    }
}
