//
//  DuplicateValueRule.swift
//  
//
//  Created by Alex Pinhasov on 10/09/2020.
//

import Foundation

public struct DuplicateValueRule: Rule {
    public var name: String = "duplicateValue"
    public var description: String = "Search for duplicate values in a localization file"
    public var row: Row?
    public var errorString: String {
        if let row = row {
            return "✏️ \"%@\" has the same value (%@) in line %@.".withArguments([row.key, row.value, row.number.description])
        }
        fatalError("Rule must have a row associated with")
    }

    /// Throws error if keys are not unique
    ///
    /// - Parameters:
    ///   - localizationFiles: Array of LocalizableFiles
    public func validation(projectFiles: [File], localizationFiles: [File]) -> [Violation] {
        var violations: [Violation] = []
        localizationFiles.forEach { file in
            var duplicateValues: [String: Row] = [:]
            file.rows.forEach({ row in
                if duplicateValues[row.value] != nil, let duplicateRow = duplicateValues[row.value] {
                    violations.append(contentsOf: [.warning(DuplicateValueRule(row: row)),
                                                   .warning(DuplicateValueRule(row: duplicateRow))])
                }
                duplicateValues[row.value] = row
            })
        }
        return violations
    }
}
