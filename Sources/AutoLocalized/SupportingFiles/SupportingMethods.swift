//
//  File 2.swift
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
func regexFor(_ pattern: String, content: String, rangeIndex: Int = 0) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    return matches.map {
        guard let range = Range($0.range(at: rangeIndex), in: content) else { fatalError("Incorrect range match") }
        return String(content[range])
    }
}

///
///
/// - Returns: A list of Files - contains path of file and all keys in it
func getFilesWithLocalizationKeys(in executableFiles: [File]) -> [File] {
    executableFiles.forEach { file in
        file.rows = file.allStringRows.enumerated().compactMap({ index, stringRow in
            var regexString = ""

            if file.path.contains("xib") || file.path.contains("storyboard") {
                regexString = "(text|title|value|placeholder)=\"([a-z|_]*?)\""
            } else {
                regexString = "(case|return|static let).*?\"([a-z|_]*?)\""
            }

            var matches = regexFor(regexString, content: stringRow, rangeIndex: 2)
            matches.removeAll(where: { $0 == "" || $0 == "\"\"" })
            matches = matches.map({ $0.replacingOccurrences(of: "\"", with: "") })

            if let match = matches.first {
                return Row(number: index + 1, key: match, value: "")
            }
            return nil
        })
    }
    return executableFiles
}

func setConfigurationFile(with configurationPathComponent: String, projectPath: String) {
    FileManager.default.changeCurrentDirectoryPath(projectPath)
    let configurationContent = content(atPath: configurationPathComponent)
    FileManager.default.changeCurrentDirectoryPath(packagePath)

    do {
        try configurationContent.write(toFile: "Sources/AutoLocalized/SupportingFiles/Configuration.swift", atomically: true, encoding: .utf8)
    } catch {
        exit(EXIT_FAILURE)
    }

    FileManager.default.changeCurrentDirectoryPath(projectPath)
}
