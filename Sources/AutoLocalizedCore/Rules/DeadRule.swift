//
//  DeadRule.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public struct DeadRule: Rule {
    public var name: String = "deadKey"
    public var description: String = "Search for unused keys in localization files"
    public var row: Row?
    public var errorString: String {
         "Dead 🔑 \"%@\", not being used.".withArguments([row?.key ?? "N/A"])
    }

    /// Throws warning if keys exist in localizable file but are not being used
    ///
    /// - Parameters
    ///   - codeFiles: Array of LocalizationCodeFile
    ///   - localizationFiles: Array of LocalizableStringFiles
    public func validation(projectFiles: [File], localizationFiles: [File]) -> [Violation] {
        guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
        let allRowsWithKeysInProject = projectFiles.compactMap { $0.rows }.reduce([], +)
        guard let allCodeFileKeys = NSOrderedSet(array: allRowsWithKeysInProject).array as? [Row] else { fatalError("Could not flat all rows") }

        var violations: [Violation] = []
        let baseKeys = Set(baseFile.rows)
        let deadKeys = baseKeys.subtracting(allCodeFileKeys)
        deadKeys.forEach({ violations.append(.warning(DeadRule(row: $0))) })
        return violations
    }
}
