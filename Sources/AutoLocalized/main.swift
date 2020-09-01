import Foundation
import AutoLocalizedCore

// We drop the first argument, which is the script execution path.
let arguments: [String] = Array(CommandLine.arguments.dropFirst())

let projectPath: String = arguments[0]
let configurationPath: String = "/AutoLocalizedConfiguration.swift"
guard !projectPath.isEmpty else { fatalError("Missing arguments in build phase")}

var scriptFinishedWithoutErrors = true
public let fileManager = FileManager.default
FileManager.default.changeCurrentDirectoryPath(projectPath)

/// List of files in currentPath - recursive
var pathFiles: [String] = {
    guard let enumerator = FileManager.default.enumerator(atPath: projectPath),
        let files = enumerator.allObjects as? [String]
        else { fatalError("Could not locate files in path directory: \(projectPath)") }
    print("Total files in project \(files.count)")
    return files
}()

// MARK: - Localization Files

/// List of localizable files
var localizableFiles: [LocalizeFile] = {
    print("Localization files:")
    return pathFiles.compactMap {
        guard NSString(string: $0).pathExtension == "strings" else { return nil }
        print("🧽 \($0)")
        return LocalizeFile(path: $0)
    }
}()

// MARK: - Other Files

/// List of project files
var projectFiles: [ProjectFile] = {
    let files: [ProjectFile] = pathFiles.compactMap({
        for excludedPath in Configurations.excludedDirectories where $0.contains(excludedPath) { return nil }
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
var violations: [Violation] = []

// MARK: - Validation
DispatchQueue.global(qos: .background).async {
    violations.append(contentsOf: validateLocalizationKeysMatch(in: localizableFiles))
    violations.append(contentsOf: validateDuplicateKeys(in: localizableFiles))
    violations.append(contentsOf: validateMissingKeys(from: projectFiles, in: localizableFiles))
    violations.append(contentsOf: validateDeadKeys(from: projectFiles, in: localizableFiles))
    group.leave()
}

// MARK: - Completion

group.wait()
print(violations)

print("Finished with \(violations.isEmpty ? "✅ SUCCESS" : "❌ ERRORS FOUND")")
violations.isEmpty ? exit(EXIT_SUCCESS) : exit(EXIT_FAILURE)


