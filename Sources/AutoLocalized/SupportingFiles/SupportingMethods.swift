//
//  File 2.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

/// Reads contents in path
///
/// - Parameter path: path of file
/// - Returns: content in file
func allStringRows(atPath path: String) -> [String] {
    guard let data = fileManager.contents(atPath: path),
        let content = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines)
        else { fatalError("Could not read from path: \(path)") }
    return content
}

/// Reads contents in path
///
/// - Parameter path: path of file
/// - Returns: content in file
func content(atPath path: String) -> String {
    guard let data = fileManager.contents(atPath: path), let content = String(data: data, encoding: .utf8)
        else { fatalError("Could not read from path: \(path)") }
    return content
}

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

/// Writes back to localizable file
func writeSorted(_ stringFiles: [LocalizationStringsFile]) {
    stringFiles.forEach({ localizeFile in
        let content = localizeFile.rows.compactMap { "\"\($0.key)\" = \"\($0.value)\";" }.joined(separator: "\n")
        do {
            try content.write(toFile: localizeFile.path, atomically: true, encoding: .utf8)
        } catch {
            print("\(fileManager.currentDirectoryPath)/\(localizeFile.path):1: error: ------------ ❌ Error: \(error) ------------")
            exit(EXIT_FAILURE)
        }
    })
}

///
///
/// - Returns: A list of Files - contains path of file and all keys in it
func getFilesWithLocalizationKeys(in executableFiles: [File]) -> [File] {
    executableFiles.forEach { file in
        file.rows = allStringRows(atPath: file.path).enumerated().compactMap({ index, stringRow in
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
