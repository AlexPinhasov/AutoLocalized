//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

/// Validate all localizable files have matching keys
///
/// - Parameter files: list of localizable files to validate
func validateLocalizationKeysMatch(in localizationFiles: [File]) {
    guard localizationFiles.count > 1, let baseEnglishLocalization = localizationFiles.first else { return }
    let files = Array(localizationFiles.suffix(from: 1))
    let baseSet = Set(baseEnglishLocalization.rows)
    files.forEach { file in
        let fileSet = Set(file.rows)
        let currentFileExtraKeysRows = fileSet.subtracting(baseSet)
        let englishFileExtraKeysRows = baseSet.subtracting(fileSet)

        currentFileExtraKeysRows.forEach({ row in
            print("\(fileManager.currentDirectoryPath)/\(baseEnglishLocalization.path):\(row.number): error: 🔑 \"\(row.key)\" appear in other localization files but is missing here.")
        })

        englishFileExtraKeysRows.forEach({ row in
            print("\(fileManager.currentDirectoryPath)/\(file.path):\(row.number): error: 🔑 \"\(row.key)\" appear in other localization files but is missing here.")
        })

        guard !currentFileExtraKeysRows.isEmpty || !englishFileExtraKeysRows.isEmpty else { return }
        scriptFinishedWithoutErrors = false
    }
}

/// Throws error if keys exist in files but missing from localization files
///
/// - Parameters:
///   - files: Array of Files
///   - localizationFiles: Array of LocalizableFiles
func validateMissingKeys(from files: [File], in localizationFiles: [File]) {
    guard let base = localizationFiles.first else { return }
    let baseKeys = Set(base.rows)
    files.forEach { file in
        let set = Set(file.rows)
        let extraKeysRows = set.subtracting(baseKeys)

        extraKeysRows.forEach({ row in
            print("\(fileManager.currentDirectoryPath)/\(file.path):\(row.number): error: 🔑 \"\(row.key)\" missing in strings file.")
        })

        guard !extraKeysRows.isEmpty else { return }
        scriptFinishedWithoutErrors = false
    }
}

/// Throws warning if keys exist in localizable file but are not being used
///
/// - Parameters
///   - codeFiles: Array of LocalizationCodeFile
///   - localizationFiles: Array of LocalizableStringFiles
func validateDeadKeys(from files: [File], in localizationFiles: [File]) {
    guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
    let allRowsWithKeysInProject = files.compactMap { $0.rows }.reduce([], +)
    guard let allCodeFileKeys = NSOrderedSet(array: allRowsWithKeysInProject).array as? [Row] else { fatalError("Could not flat all rows") }

    let baseKeys = Set(baseFile.rows)
    let deadKeys = baseKeys.subtracting(allCodeFileKeys)
    deadKeys.forEach({ row in
        localizationFiles.forEach({ file in
            print("\(fileManager.currentDirectoryPath)/\(file.path):\(row.number): warning: Dead 🔑 \"\(row.key)\", not being used.")
        })
    })
}

/// Throws error if keys are not unique
///
/// - Parameters:
///   - localizationFiles: Array of LocalizableFiles
func validateDuplicateKeys(in localizationFiles: [File]) {
    localizationFiles.forEach { file in
        var duplicateKeys: [String: Row] = [:]
        file.rows.forEach({ row in
            if duplicateKeys[row.key] != nil, let duplicateRow = duplicateKeys[row.key] {
                print("\(fileManager.currentDirectoryPath)/\(file.path):\(row.number): error: 🔑 \"\(row.key)\" has duplicate in line \(row.number).")
                print("\(fileManager.currentDirectoryPath)/\(file.path):\(duplicateRow.number): error: 🔑 \"\(duplicateRow.key)\" has duplicate in line \(row.number).")
            }
            duplicateKeys[row.key] = row
        })
    }
}
