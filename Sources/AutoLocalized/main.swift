#!/usr/bin/xcrun swift

import Foundation

// We drop the first argument, which is the script execution path.
let arguments: [String] = Array(CommandLine.arguments.dropFirst())

guard let projectPath: String = arguments.first,
    let configurationPath: String = arguments.last,
    let configurationPathComponent = NSString(string: configurationPath).pathComponents.last else { exit(EXIT_FAILURE) }

var scriptFinishedWithoutErrors = true

let fileManager = FileManager.default
let packagePath = fileManager.currentDirectoryPath
setConfigurationFile(with: configurationPathComponent, projectPath: projectPath)

/// List of files in currentPath - recursive
var pathFiles: [String] = {
    guard let enumerator = fileManager.enumerator(atPath: projectPath),
        let files = enumerator.allObjects as? [String]
        else { fatalError("Could not locate files in path directory: \(projectPath)") }
    return files
}()

// MARK: - Localization Files

/// List of localizable files - not including Localizable files in the Pods
var localizableFiles: [LocalizeFile] = {
    return pathFiles.compactMap {
        guard !$0.contains("Pods") && NSString(string: $0).pathExtension == "strings" else { return nil }
        return LocalizeFile(path: $0)
    }
}()

// MARK: - Other Files

/// List of executable files
var projectFiles: [File] = {
    func shouldUseFile(atPath path: String) -> Bool {
        return Configurations.supportedFileExtensions.contains(NSString(string: path).pathExtension) &&
            Configurations.excludedDirectories.compactMap({ path.contains($0) }).contains(false)
    }

    func shouldIgnoreFile(atPath path: String) -> Bool {
        return regexFor("autolocalized:disable", content: content(atPath: path), rangeIndex: 0).count != 1
    }

    return pathFiles.compactMap({
        guard shouldUseFile(atPath: $0) && shouldIgnoreFile(atPath: $0) else { return nil }
        return File(path: $0, rows: [])
    })
}()

func content(atPath path: String, fileManager: FileManager = FileManager.default) -> String {
    guard let data = fileManager.contents(atPath: path), let content = String(data: data, encoding: .utf8)
        else { fatalError("Could not read from path: \(path)") }
    return content
}

// MARK: - Execution

localizableFiles.forEach({ $0.writeSorted() })
validateLocalizationKeysMatch(in: localizableFiles)
validateDuplicateKeys(in: localizableFiles)

let filesWithLocalizationKeys = getFilesWithLocalizationKeys(in: projectFiles)
validateMissingKeys(from: filesWithLocalizationKeys, in: localizableFiles)
validateDeadKeys(from: filesWithLocalizationKeys, in: localizableFiles)

print("Finished with \(scriptFinishedWithoutErrors ? "✅ SUCCESS" : "❌ ERRORS FOUND")")
scriptFinishedWithoutErrors ? exit(EXIT_SUCCESS) : exit(EXIT_FAILURE)


