//
//  ValidationMethods.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

public typealias CustomValidator = ([File], [LocalizeFile]) -> [Violation]
public class Validators {

    public var customValidators: [CustomValidator] = []

    public init() {}

    public func execute() -> [Violation] {
        var violations: [Violation] = []
        violations.append(contentsOf: validateLocalizationKeysMatch(in: localizableFiles))
        violations.append(contentsOf: validateDuplicateKeys(in: localizableFiles))
        violations.append(contentsOf: validateMissingKeys(from: projectFiles, in: localizableFiles))
        violations.append(contentsOf: validateDeadKeys(from: projectFiles, in: localizableFiles))
        customValidators.forEach({ violations.append(contentsOf: $0(projectFiles, localizableFiles)) })
        return violations
    }

    /// Validate all localizable files have matching keys
    ///
    /// - Parameter files: list of localizable files to validate
    func validateLocalizationKeysMatch(in localizationFiles: [File]) -> [Violation] {
        guard localizationFiles.count > 1, let baseLocalizationFile = localizationFiles.first else { return [] }
        let files = Array(localizationFiles.suffix(from: 1))
        let baseSet = Set(baseLocalizationFile.rows)
        var violations: [Violation] = []

        files.forEach { file in
            let fileSet = Set(file.rows)
            let currentFileExtraKeysRows = fileSet.subtracting(baseSet)
            let englishFileExtraKeysRows = baseSet.subtracting(fileSet)
            currentFileExtraKeysRows.forEach({ violations.append(.error(MatchRule(forRow: $0))) })
            englishFileExtraKeysRows.forEach({ violations.append(.error(MatchRule(forRow: $0))) })
        }
        return violations
    }

    /// Throws error if keys exist in files but missing from localization files
    ///
    /// - Parameters:
    ///   - files: Array of Files
    ///   - localizationFiles: Array of LocalizableFiles
    func validateMissingKeys(from files: [File], in localizationFiles: [File]) -> [Violation] {
        guard let base = localizationFiles.first else { return [] }
        let baseKeys = Set(base.rows)
        var violations: [Violation] = []

        files.forEach { file in
            let fileKeysSet = Set(file.rows)
            let extraKeysRows = fileKeysSet.subtracting(baseKeys)
            extraKeysRows.forEach({ violations.append(.error(MissingRule(forRow: $0))) })
        }
        return violations
    }

    /// Throws warning if keys exist in localizable file but are not being used
    ///
    /// - Parameters
    ///   - codeFiles: Array of LocalizationCodeFile
    ///   - localizationFiles: Array of LocalizableStringFiles
    func validateDeadKeys(from files: [File], in localizationFiles: [File]) -> [Violation] {
        guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
        let allRowsWithKeysInProject = files.compactMap { $0.rows }.reduce([], +)
        guard let allCodeFileKeys = NSOrderedSet(array: allRowsWithKeysInProject).array as? [Row] else { fatalError("Could not flat all rows") }

        var violations: [Violation] = []
        let baseKeys = Set(baseFile.rows)
        let deadKeys = baseKeys.subtracting(allCodeFileKeys)
        deadKeys.forEach({ violations.append(.warning(DeadRule(forRow: $0))) })
        return violations
    }

    /// Throws error if keys are not unique
    ///
    /// - Parameters:
    ///   - localizationFiles: Array of LocalizableFiles
    func validateDuplicateKeys(in localizationFiles: [File]) -> [Violation] {
        var violations: [Violation] = []
        localizationFiles.forEach { file in
            var duplicateKeys: [String: Row] = [:]
            file.rows.forEach({ row in
                if duplicateKeys[row.key] != nil, let duplicateRow = duplicateKeys[row.key] {
                    violations.append(contentsOf: [.error(DuplicateRule(forRow: row)),
                                                   .error(DuplicateRule(forRow: duplicateRow))])
                }
                duplicateKeys[row.key] = row
            })
        }
        return violations
    }
}
