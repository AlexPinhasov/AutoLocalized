//
//  LocalizeFile.swift
//  
//
//  Created by Alex Pinhasov on 23/08/2020.
//

import Foundation

class LocalizeFile: File {

    // MARK: - Properties

    var path: String
    var rows: [Row] = []

    // MARK: - Init

    init(path: String) {
        self.path = path
        self.rows = parseRows()
        rows.sort(by: { $0.key < $1.key })
        rows.enumerated().forEach({ $1.setNewRowNumber($0 + 1) })
        writeSorted()
    }

    /// Parses rows in file - Throws error if localizable file have duplicated keys
    /// - Returns: A list of rows in file
    func parseRows() -> [Row] {
        var foundErrorInRegex = false

        let rows: [Row] = allStringRows.enumerated().compactMap({ index, rowString in
            guard !rowString.isEmpty else { return nil }

            let keys = regexFor("\"([^\"]*?)\"(?= =)", content: rowString, rangeIndex: 1)
            let values = regexFor("(?<== )\"(.*?)\"(?=;)", content: rowString, rangeIndex: 1)

            if keys.count > 1 || values.count > 1 {
                foundErrorInRegex = true
                print("\(FileManager.default.currentDirectoryPath)/\(path):\(index + 1): error: Error parsing contents: Line should contain only 1 key and 1 value")
            } else if keys.isEmpty || values.isEmpty {
                foundErrorInRegex = true
                print("\(FileManager.default.currentDirectoryPath)/\(path):\(index + 1): error: Error parsing contents: No \(keys.isEmpty ? "key" : "value") found")
            }

            guard let key = keys.first, let value = values.first else { return nil }
            return Row(in: self, number: 0, key: key, value: value)
        })

        guard !foundErrorInRegex else { exit(EXIT_FAILURE) }
        return rows
    }

    /// Sort keys and write to file

    func writeSorted() {
        do {
            let content = rows.compactMap { $0.keyValue }.joined(separator: "\n")
            guard !content.isEmpty else { fatalError("Cant get \(path) content") }
            try content.write(toFile: path, atomically: true, encoding: .utf8)
        } catch {
            print("\(FileManager.default.currentDirectoryPath)/\(path):1: error: ------------ ❌ Error: \(error) ------------")
            exit(EXIT_FAILURE)
        }
    }
}
