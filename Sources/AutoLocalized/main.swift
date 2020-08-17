#!/usr/bin/xcrun --sdk macosx swift

import Foundation
import Darwin

// We drop the first argument, which is the script execution path.
let arguments: [String] = Array(CommandLine.arguments.dropFirst())

guard let currentPath: String = arguments.first else { exit(EXIT_FAILURE) }
var scriptFinishedWithoutErrors = true


let fileManager = FileManager.default
FileManager.default.changeCurrentDirectoryPath(currentPath)

/// List of files in currentPath - recursive
var pathFiles: [String] = {
    guard let enumerator = fileManager.enumerator(atPath: currentPath),
        let files = enumerator.allObjects as? [String]
        else { fatalError("Could not locate files in path directory: \(currentPath)") }
    return files
}()

/// List of localizable files - not including Localizable files in the Pods
var localizableFiles: [LocalizationStringsFile] = {
    let files = pathFiles.filter { $0.hasSuffix("Localize.strings") && !$0.contains("Pods") }.map(LocalizationStringsFile.init(path:))
    guard files.count > 1 else {
        print("------------ 📚 Only 1 localize file found ------------")
        exit(EXIT_SUCCESS)
    }
    return files
}()

/// List of executable files
var projectFiles: [File] = {
    return pathFiles.filter { (!$0.localizedCaseInsensitiveContains("test") && NSString(string: $0).pathExtension == "swift"  && !NSString(string: $0).contains("Pods")) && NSString(string: $0).contains("Selina/Localization/Enums") || NSString(string: $0).pathExtension == "xib" || NSString(string: $0).pathExtension == "storyboard"}.compactMap({ File(path: $0, rows: []) })
}()

/// Throws error is ALL localizable files does not have matching keys
///
/// - Parameter files: list of localizable files to validate
func validateLocalizationKeysMatch(in files: [LocalizationStringsFile]) {
    print("------------ 📚 Validating keys match in all localizable files ------------")
    guard let baseEnglishLocalization = files.first else { return }
    let files = Array(files.suffix(from: 1))
    let baseSet = Set(baseEnglishLocalization.rows)
    files.forEach { file in
        let fileSet = Set(file.rows)

        let currentFileExtraKeysRows = fileSet.subtracting(baseSet)
        let englishFileExtraKeysRows = baseSet.subtracting(fileSet)

        currentFileExtraKeysRows.forEach({ row in
            print("\(currentPath)/\(baseEnglishLocalization.path):\(row.number + 1): error: 🔑 \"\(row.key)\" appear in other localization files but is missing here.")
        })

        englishFileExtraKeysRows.forEach({ row in
            print("\(currentPath)/\(file.path):\(row.number + 1): error: 🔑 \"\(row.key)\" appear in other localization files but is missing here.")
        })

        guard !currentFileExtraKeysRows.isEmpty || !englishFileExtraKeysRows.isEmpty else { return }
        scriptFinishedWithoutErrors = false
    }
}

/// Throws error if localizable files are missing keys
///
/// - Parameters:
///   - codeFiles: Array of LocalizationCodeFile
///   - localizationFiles: Array of LocalizableStringFiles
func validateMissingKeys(from codeFiles: [File], in localizationFiles: [LocalizationStringsFile]) {
    print("------------ Checking for missing keys -----------")
    guard let base = localizationFiles.first else { return }
    let baseKeys = Set(base.rows)
    codeFiles.forEach { file in
        let set = Set(file.rows)
        let extraKeysRows = set.subtracting(baseKeys)

        extraKeysRows.forEach({ row in
            print("\(fileManager.currentDirectoryPath)/\(file.path):\(row.number + 1): error: 🔑 \"\(row.key)\" located in -> 📁 \(file.path), missing in strings file.")
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
func validateDeadKeys(from codeFiles: [File], in localizationFiles: [LocalizationStringsFile]) {
    print("------------ Checking for any dead keys in localizable file -----------")
    guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
    let allRowsWithKeysInProject = codeFiles.compactMap { $0.rows }.reduce([], +)
    guard let allCodeFileKeys = NSOrderedSet(array: allRowsWithKeysInProject).array as? [Row] else { fatalError("Could not locate flat all rows") }

    let baseKeys = Set(baseFile.rows)
    let deadKeys = baseKeys.subtracting(allCodeFileKeys)
    deadKeys.forEach({ row in
        localizationFiles.forEach({ file in
            print("\(fileManager.currentDirectoryPath)/\(file.path):\(row.number + 1): warning: Dead 🔑 \"\(row.key)\", not being used.")
        })
    })
}

validateLocalizationKeysMatch(in: localizableFiles)
writeSorted(localizableFiles)

let filesWithLocalizationKeys = getFilesWithLocalizationKeys(in: projectFiles)
validateMissingKeys(from: filesWithLocalizationKeys, in: localizableFiles)
validateDeadKeys(from: filesWithLocalizationKeys, in: localizableFiles)

print("------------ SUCCESS ------------")
scriptFinishedWithoutErrors ? exit(EXIT_SUCCESS) : exit(EXIT_FAILURE)


