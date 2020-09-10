//
//  MissingRule.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct MissingRule: Rule {
    public var name: String = "missingKey"
    public var description: String = "Search for missing keys in localization files found in project files"
    public var row: Row?
    public var errorString: String {
        if let row = row {
           return "🔑 \"%@\" appears here but is missing from localization files.".withArguments([row.key])
        }
        fatalError("Rule must have a row associated with")
    }

    /// Throws error if keys exist in files but missing from localization files
    ///
    /// - Parameters:
    ///   - files: Array of Files
    ///   - localizationFiles: Array of LocalizableFiles
    public func validation(projectFiles: [File], localizationFiles: [File]) -> [Violation] {
        guard let base = localizationFiles.first else { return [] }
        let baseKeys = Set(base.rows)
        var violations: [Violation] = []

        projectFiles.forEach { file in
            let fileKeysSet = Set(file.rows)
            let extraKeysRows = fileKeysSet.subtracting(baseKeys)
            extraKeysRows.forEach({ violations.append(.error(MissingRule(row: $0))) })
        }
        return violations
    }
}
