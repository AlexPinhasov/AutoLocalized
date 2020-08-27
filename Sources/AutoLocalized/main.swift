#!/usr/bin/xcrun swift

import Foundation

// We drop the first argument, which is the script execution path.
let arguments: [String] = Array(CommandLine.arguments.dropFirst())

let projectPath: String = arguments[0]
let projectName: String = arguments[1]
let configurationPath: String = arguments[2]
guard !projectPath.isEmpty, !projectName.isEmpty, !configurationPath.isEmpty else { fatalError("Missing arguments in build phase")}
guard let configurationPathComponent = NSString(string: configurationPath).pathComponents.last else { exit(EXIT_FAILURE) }

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
    print("Localization files:")
    return pathFiles.compactMap {
        guard !$0.contains("Pods") && NSString(string: $0).pathExtension == "strings" else { return nil }
        print("🧽 \($0)")
        return LocalizeFile(path: $0)
    }
}()

// MARK: - Other Files

/// List of project files
var projectFiles: [ProjectFile] = {
    let files: [ProjectFile] = pathFiles.compactMap({
        for excludedPath in Configurations.excludedDirectories where $0.contains(excludedPath) || NSString(string: $0).pathComponents.first != projectName { return nil }
        guard Configurations.supportedFileExtensions.contains(NSString(string: $0).pathExtension) else { return nil }
        let projectFile = ProjectFile(path: $0)
        if projectFile.rows.isEmpty { return nil }
        return projectFile
    })


    let sortedByExtension = files.sorted(by: { NSString(string: $0.path).pathExtension < NSString(string: $1.path).pathExtension })
    var currentExtension = ""
    sortedByExtension.forEach({
        let fileExtension = NSString(string: $0.path).pathExtension
        if fileExtension != currentExtension {
            currentExtension = fileExtension
            print("\nAll \(currentExtension) files:\n")
        }
        print("🧽 \(NSString(string: $0.path).lastPathComponent) has \($0.rows.count) keys: 🔑 \($0.rows.compactMap({ $0.key }))")
    })

    return files
}()

// MARK: - Sort Localization files key

localizableFiles.forEach({ $0.writeSorted() })

let group = DispatchGroup()
group.enter()

// MARK: - Validation
DispatchQueue.global(qos: .background).async {
    validateLocalizationKeysMatch(in: localizableFiles)
    validateDuplicateKeys(in: localizableFiles)
    validateMissingKeys(from: projectFiles, in: localizableFiles)
    validateDeadKeys(from: projectFiles, in: localizableFiles)
    group.leave()
}

// MARK: - Completion

group.wait()
print("Finished with \(scriptFinishedWithoutErrors ? "✅ SUCCESS" : "❌ ERRORS FOUND")")
scriptFinishedWithoutErrors ? exit(EXIT_SUCCESS) : exit(EXIT_FAILURE)


