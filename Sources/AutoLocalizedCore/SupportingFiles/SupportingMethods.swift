//
//  SupportingMethods.swift
//
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

/// Returns a list of strings that match regex pattern from content
///
/// - Parameters:
///   - pattern: regex pattern
///   - content: content to match
/// - Returns: list of results
public func regexFor(_ pattern: String, content: String, rangeIndex: Int = 0) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    return matches.map {
        guard let range = Range($0.range(at: rangeIndex), in: content) else { fatalError("Incorrect range match") }
        return String(content[range])
    }
}

/// Copy the content of the configuration file located in your project
///
/// - Parameters:
///   - configurationPathComponent: path for configuration file
///   - projectPath: path for your project
public func setConfigurationFile(with configurationPath: String, projectPath: String, packagePath: String, fileManager: FileManager) {
    fileManager.changeCurrentDirectoryPath(projectPath)
    guard let data = fileManager.contents(atPath: projectPath  + configurationPath), let configurationContent = String(data: data, encoding: .utf8) else { fatalError("Could not read from path: \(projectPath)") }

    fileManager.changeCurrentDirectoryPath(packagePath)
    do {
        try configurationContent.write(toFile: "AutoLocalizedCore/Sources/AutoLocalized/SupportingFiles/Configuration.swift", atomically: true, encoding: .utf8)
    } catch {
        exit(EXIT_FAILURE)
    }
    fileManager.changeCurrentDirectoryPath(projectPath)
    FileManager.default.changeCurrentDirectoryPath(projectPath)
}
