//
//  ProjectFile.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

class ProjectFile: File {
    var path: String
    var rows: [Row] = []
    var fileExtension: FileExtension

    init(path: String, fileExtension: FileExtension) {
        self.path = path
        self.fileExtension = fileExtension
        self.rows = parseRows()
    }

    /// - Returns: A list of rows in file
    func parseRows() -> [Row] {
        var shouldSkipLine = false
        return allStringRows.enumerated().compactMap({ index, stringRow in
            if shouldSkipLine {
                shouldSkipLine = !stringRow.contains("autolocalized:enable")
                return nil
            }
            if stringRow.contains("autolocalized:disable") {
                shouldSkipLine = true
                return nil
            }

            var matches = regexFor(fileExtension.regex, content: stringRow, rangeIndex: fileExtension.matchIndex)
            matches.removeAll(where: { $0 == "" || $0 == "\"\"" })
            matches = matches.map({ $0.replacingOccurrences(of: "\"", with: "") })

            if let match = matches.first {
                return Row(in: self, number: index + 1, key: match, value: "")
            }
            return nil
        })
    }
}
