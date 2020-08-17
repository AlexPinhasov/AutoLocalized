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
        let rowsInFile: [String] = contents(atPath: path)
        var foundErrorInRegex = false

        var rows: [Row] = rowsInFile.enumerated().compactMap({ index, rowString in
            let rowString = rowString.replacingOccurrences(of: "\n+", with: "", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines)

            let keys = regexFor("\"([^\"]*?)\"(?= =)", content: rowString)
            let values = regexFor("(?<== )\"(.*?)\"(?=;)", content: rowString)

            if keys.count > 1 || values.count > 1 {
                foundErrorInRegex = true
                print("\(fileManager.currentDirectoryPath)/\(path):\(index): error: Error parsing contents: Line should contain only 1 key and 1 value")
            } else if keys.isEmpty || values.isEmpty {
                foundErrorInRegex = true
                print("\(fileManager.currentDirectoryPath)/\(path):\(index): error: Error parsing contents: No \(keys.isEmpty ? "key" : "value") found")
            }

            if let key = keys.first, let value = values.first {
                return Row(number: 0, key: key, value: value)
            }
            return nil
        })

        guard !foundErrorInRegex else { exit(EXIT_FAILURE) }
        print("------------ 🧮 Sort and remove whitespaces: \(path) ------------")
        rows.sort(by: { $0.key < $1.key })
        rows.enumerated().forEach({ index, row in
            row.number = index
            row.key = row.key.replacingOccurrences(of: "\"", with: "")
            row.value.removeFirst()
            row.value.removeLast()
        })
        return rows
//print("------------ Validating duplicate keys: \(path) ------------")
//        return zip(keys, values).reduce(into: [String: String]()) { results, keyValue in
//            if results[keyValue.0] != nil {
//                printPretty("error: Found duplicate key: \(keyValue.0) in file: \(path)")
//                exit(EXIT_FAILURE)
//            }
//            results[keyValue.0] = keyValue.1
//        }
    }
}
