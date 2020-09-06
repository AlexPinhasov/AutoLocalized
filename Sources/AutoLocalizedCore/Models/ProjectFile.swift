//
//  ProjectFile.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

public class ProjectFile: File {
    public var path: String
    public var rows: [Row] = []
    public var fileExtension: FileExtension

    public init(path: String, fileExtension: FileExtension) {
        self.path = path
        self.fileExtension = fileExtension
        self.rows = parseRows()
    }

    ///
    ///
    /// - Returns: A list of Files - contains path of file and all keys in it
    public func parseRows() -> [Row] {
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
