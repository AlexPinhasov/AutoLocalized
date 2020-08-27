//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 27/08/2020.
//

import Foundation

enum PrintType: String {
    case error, warning
}

enum Violation {
    case duplicateKey, deadKey, missingKey, localizeFilesDontMatch

    var string: String {
        switch self {
        case .duplicateKey: return "🔑 \"%@\" has a duplicate in line %@."
        case .deadKey: return "Dead 🔑 \"%@\", not being used."
        case .missingKey: return "🔑 \"%@\" is missing in strings files."
        case .localizeFilesDontMatch: return "🔑 \"%@\" appears in other localization files but is missing here."
        }
    }

    func outputString(using row: Row) -> String {
        switch self {
        case .duplicateKey: return self.string.withArguments([row.key, row.number.description])
        case .deadKey: return self.string.withArguments([row.key])
        case .missingKey: return self.string.withArguments([row.key])
        case .localizeFilesDontMatch: return self.string.withArguments([row.key])
        }
    }
}

func print(type: PrintType, violation: Violation, for row: Row) {
    guard let file = row.file else { return }
    let filePathAndLine: String = "\(fileManager.currentDirectoryPath)/\(file.path):\(row.number)"
    print("\(filePathAndLine): \(type.rawValue): \(violation.outputString(using: row))")
}

