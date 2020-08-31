//
//  ValidationMethods.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

/// Validate all localizable files have matching keys
///
/// - Parameter files: list of localizable files to validate
public func validateLocalizationKeysMatch(in localizationFiles: [File]) {
    guard localizationFiles.count > 1, let baseLocalizationFile = localizationFiles.first else { return }
    let files = Array(localizationFiles.suffix(from: 1))
    let baseSet = Set(baseLocalizationFile.rows)
    files.forEach { file in
        let fileSet = Set(file.rows)
        let currentFileExtraKeysRows = fileSet.subtracting(baseSet)
        let englishFileExtraKeysRows = baseSet.subtracting(fileSet)

        currentFileExtraKeysRows.forEach({ row in
            print(type: .error, violation: .localizeFilesDontMatch, for: row)
        })

        englishFileExtraKeysRows.forEach({ row in
            print(type: .error, violation: .localizeFilesDontMatch, for: row)
        })
    }
}

/// Throws error if keys exist in files but missing from localization files
///
/// - Parameters:
///   - files: Array of Files
///   - localizationFiles: Array of LocalizableFiles
public func validateMissingKeys(from files: [File], in localizationFiles: [File]) {
    guard let base = localizationFiles.first else { return }
    let baseKeys = Set(base.rows)
    files.forEach { file in
        let fileKeysSet = Set(file.rows)
        let extraKeysRows = fileKeysSet.subtracting(baseKeys)
        extraKeysRows.forEach({ row in
            print(type: .error, violation: .missingKey, for: row)
        })
    }
}

/// Throws warning if keys exist in localizable file but are not being used
///
/// - Parameters
///   - codeFiles: Array of LocalizationCodeFile
///   - localizationFiles: Array of LocalizableStringFiles
public func validateDeadKeys(from files: [File], in localizationFiles: [File]) {
    guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
    let allRowsWithKeysInProject = files.compactMap { $0.rows }.reduce([], +)
    guard let allCodeFileKeys = NSOrderedSet(array: allRowsWithKeysInProject).array as? [Row] else { fatalError("Could not flat all rows") }

    let baseKeys = Set(baseFile.rows)
    let deadKeys = baseKeys.subtracting(allCodeFileKeys)
    deadKeys.forEach({
        print(type: .warning, violation: .deadKey, for: $0)
    })
}

/// Throws error if keys are not unique
///
/// - Parameters:
///   - localizationFiles: Array of LocalizableFiles
public func validateDuplicateKeys(in localizationFiles: [File]) {
    localizationFiles.forEach { file in
        var duplicateKeys: [String: Row] = [:]
        file.rows.forEach({ row in
            if duplicateKeys[row.key] != nil, let duplicateRow = duplicateKeys[row.key] {
                print(type: .error, violation: .duplicateKey, for: row)
                print(type: .error, violation: .duplicateKey, for: duplicateRow)
            }
            duplicateKeys[row.key] = row
        })
    }
}

