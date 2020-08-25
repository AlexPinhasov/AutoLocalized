//
//  File 2.swift
//  
//
//  Created by Alex Pinhasov on 23/08/2020.
//

import Foundation

class LocalizeFile: File {
    convenience init(path: String) {
        self.init(path: path, rows: [])
        parseRows()
    }

    /// Parses contents of a file to localizable keys and values - Throws error if localizable file have duplicated keys
    ///
    /// - Parameter path: Localizable file paths
    /// - Returns: localizable key and value for content at path
    private func parseRows() {
        var foundErrorInRegex = false

        rows = allStringRows.enumerated().compactMap({ index, rowString in
            guard !rowString.isEmpty else { return nil }

            let keys = regexFor("\"([^\"]*?)\"(?= =)", content: rowString, rangeIndex: 1)
            let values = regexFor("(?<== )\"(.*?)\"(?=;)", content: rowString, rangeIndex: 1)

            if keys.count > 1 || values.count > 1 {
                foundErrorInRegex = true
                print("\(fileManager.currentDirectoryPath)/\(path):\(index + 1): error: Error parsing contents: Line should contain only 1 key and 1 value")
            } else if keys.isEmpty || values.isEmpty {
                foundErrorInRegex = true
                print("\(fileManager.currentDirectoryPath)/\(path):\(index + 1): error: Error parsing contents: No \(keys.isEmpty ? "key" : "value") found")
            }

            guard let key = keys.first, let value = values.first else { return nil }
            return Row(number: 0, key: key, value: value)
        })

        guard !foundErrorInRegex else { exit(EXIT_FAILURE) }
        rows.sort(by: { $0.key < $1.key })
        rows.enumerated().forEach({ $1.number = $0 + 1 })
    }

    /// Writes back to localizable file
    func writeSorted() {
        do {
            let content = rows.compactMap { $0.keyValue }.joined(separator: "\n")
            try content.write(toFile: path, atomically: true, encoding: .utf8)
        } catch {
            print("\(fileManager.currentDirectoryPath)/\(path):1: error: ------------ ❌ Error: \(error) ------------")
            exit(EXIT_FAILURE)
        }
    }
}
