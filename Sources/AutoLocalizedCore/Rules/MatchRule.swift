//
//  MatchRule.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct MatchRule: Rule {
    public var name: String = "localizeFilesDontMatch"
    public var description: String = "Make sure localization files keys match"
    public var row: Row?
    public var errorString: String {
        if let row = row {
           return "🔑 \"%@\" appears in other localization files but is missing here.".withArguments([row.key])
        }
        fatalError("Rule must have a row associated with")
    }

    /// Validate all localizable files have matching keys
    ///
    /// - Parameter files: list of localizable files to validate
    public func validation(projectFiles: [File], localizationFiles: [File]) -> [Violation] {
        guard localizationFiles.count > 1, let baseLocalizationFile = localizationFiles.first else { return [] }
        let files = Array(localizationFiles.suffix(from: 1))
        let baseSet = Set(baseLocalizationFile.rows)
        var violations: [Violation] = []

        files.forEach { file in
            let fileSet = Set(file.rows)
            let currentFileExtraKeysRows = fileSet.subtracting(baseSet)
            let englishFileExtraKeysRows = baseSet.subtracting(fileSet)
            currentFileExtraKeysRows.forEach({ violations.append(.error(MatchRule(row: $0))) })
            englishFileExtraKeysRows.forEach({ violations.append(.error(MatchRule(row: $0))) })
        }
        return violations
    }
}
