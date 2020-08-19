

import Foundation

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

// MARK: - Localization Files

/// List of localizable files - not including Localizable files in the Pods
var localizableFiles: [LocalizationStringsFile] = {
    return pathFiles.filter { $0.hasSuffix("Localize.strings") && !$0.contains("Pods") }.map(LocalizationStringsFile.init(path:))
}()

// MARK: - Other Files

/// List of executable files
var projectFiles: [File] = {
    func shouldUseFile(atPath path: String) -> Bool {
        return (NSString(string: path).pathExtension != "strings"
                && !path.localizedCaseInsensitiveContains("test")
                && NSString(string: path).pathExtension == "swift"
                && !NSString(string: path).contains("Pods")
                && NSString(string: path).contains("Selina/")
                )
                || NSString(string: path).pathExtension == "xib"
                || NSString(string: path).pathExtension == "storyboard"
    }

    func shouldIgnoreFile(atPath path: String) -> Bool {
        return regexFor("// autolocalized:disable", content: content(atPath: path), rangeIndex: 0).count != 1
    }

    return pathFiles.filter({ shouldUseFile(atPath: $0) && shouldIgnoreFile(atPath: $0) }).compactMap({ File(path: $0, rows: []) })
}()

// MARK: - Execution

writeSorted(localizableFiles)
validateLocalizationKeysMatch(in: localizableFiles)
validateDuplicateKeys(in: localizableFiles)

let filesWithLocalizationKeys = getFilesWithLocalizationKeys(in: projectFiles)
validateMissingKeys(from: filesWithLocalizationKeys, in: localizableFiles)
validateDeadKeys(from: filesWithLocalizationKeys, in: localizableFiles)

print("Finished with \(scriptFinishedWithoutErrors ? "✅ SUCCESS" : "❌ ERRORS FOUND")")
scriptFinishedWithoutErrors ? exit(EXIT_SUCCESS) : exit(EXIT_FAILURE)


