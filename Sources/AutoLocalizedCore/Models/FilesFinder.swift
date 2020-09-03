//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 03/09/2020.
//

import Foundation

/// List of files in currentPath - recursive
public var pathFiles: [String] = {
    guard let enumerator = FileManager.default.enumerator(atPath: FileManager.default.currentDirectoryPath),
        let files = enumerator.allObjects as? [String]
        else { fatalError("Could not locate files in path directory: \(FileManager.default.currentDirectoryPath)") }
    print("Total files in project \(files.count)")
    return files
}()

// MARK: - Localization Files

/// List of localizable files
public var localizableFiles: [LocalizeFile] = {
    print("Localization files:")
    return pathFiles.compactMap {
        guard NSString(string: $0).pathExtension == "strings" else { return nil }
        print("🧽 \($0)")
        return LocalizeFile(path: $0)
    }
}()

// MARK: - Other Files

/// List of project files
public var projectFiles: [ProjectFile] = {
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
