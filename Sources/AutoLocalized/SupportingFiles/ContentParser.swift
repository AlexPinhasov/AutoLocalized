//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 15/08/2020.
//

import Foundation

struct ContentParser {
    /// Parses contents of a file to localizable keys and values - Throws error if localizable file have duplicated keys
    ///
    /// - Parameter path: Localizable file paths
    /// - Returns: localizable key and value for content at path
    static func parse(_ path: String) -> [Row] {
        let rowsInFile: [String] = allStringRows(atPath: path)
        var foundErrorInRegex = false

        var rows: [Row] = rowsInFile.enumerated().compactMap({ index, rowString in
            guard !rowString.isEmpty else { return nil }

            let rowString = rowString.replacingOccurrences(of: "\n+", with: "", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines)
            let keys = regexFor("\"([^\"]*?)\"(?= =)", content: rowString)
            let values = regexFor("(?<== )\"(.*?)\"(?=;)", content: rowString)

            if keys.count > 1 || values.count > 1 {
                foundErrorInRegex = true
                print("\(fileManager.currentDirectoryPath)/\(path):\(index + 1): error: Error parsing contents: Line should contain only 1 key and 1 value")
            } else if keys.isEmpty || values.isEmpty {
                foundErrorInRegex = true
                print("\(fileManager.currentDirectoryPath)/\(path):\(index + 1): error: Error parsing contents: No \(keys.isEmpty ? "key" : "value") found")
            }

            if let key = keys.first, let value = values.first {
                return Row(number: 0, key: key, value: value)
            }
            return nil
        })

        guard !foundErrorInRegex else { exit(EXIT_FAILURE) }
        rows.sort(by: { $0.key < $1.key })
        rows.enumerated().forEach({ index, row in
            row.number = index + 1
            row.key = row.key.replacingOccurrences(of: "\"", with: "")
            row.value.removeFirst()
            row.value.removeLast()
        })
        return rows
    }
}
