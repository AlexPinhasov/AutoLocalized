//
//  DuplicateKeyRule.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct DuplicateKeyRule: Rule {
    public var name: String = "duplicateKey"
    public var description: String = "Search for duplicate keys in a localization file"
    public var row: Row?
    public var rowLinked: Row?
    public var errorString: String {
        if let row = row {
           return "🔑 \"%@\" has a duplicate in line %@.".withArguments([row.key, rowLinked?.number.description ?? row.number.description])
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
            var duplicateKeys: [String: Row] = [:]
            file.rows.forEach({ row in
                if duplicateKeys[row.key] != nil, let duplicateRow = duplicateKeys[row.key] {
                    violations.append(contentsOf: [.error(DuplicateKeyRule(row: row, rowLinked: duplicateRow)),
                                                   .error(DuplicateKeyRule(row: duplicateRow, rowLinked: row))])
                }
                duplicateKeys[row.key] = row
            })
        }
        return violations
    }
}
