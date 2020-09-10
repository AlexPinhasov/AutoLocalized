//
//  FileFinder.swift
//  
//
//  Created by Alex Pinhasov on 03/09/2020.
//

import Foundation

class FileFinder {

    // MARK: - Properties

    private let configuration: Configuration

    // MARK: - Init

    init(with configuration: Configuration) {
        self.configuration = configuration
    }

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
    public lazy var localizableFiles: [LocalizeFile] = {
        print("Localization files:")
        return pathFiles.compactMap {
            guard NSString(string: $0).pathExtension == "strings" else { return nil }
            print("🧽 \($0)")
            return LocalizeFile(path: $0)
        }
    }()

    // MARK: - Other Files

    /// List of project files
    public lazy var projectFiles: [ProjectFile] = {
        let files: [ProjectFile] = pathFiles.compactMap({ path in
            for excludedPath in configuration.excludedDirectories where path.contains(excludedPath) { return nil }
            guard let fileExtension = configuration.supportedFileExtensions.first(where: { $0.extension == NSString(string: path).pathExtension }), !fileExtension.regex.isEmpty else { return nil }
            let projectFile = ProjectFile(path: path, fileExtension: fileExtension)
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
}
