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

    public init(path: String) {
        self.path = path
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
            var regexString = ""

            if path.contains("xib") || path.contains("storyboard") {
                regexString = "(text|title|value|placeholder)=\"([a-z|_]*?)\""
            } else {
                regexString = "(case|return|static let).*?\"([a-z|_]*?)\""
            }
            var matches = regexFor(regexString, content: stringRow, rangeIndex: 2)
            matches.removeAll(where: { $0 == "" || $0 == "\"\"" })
            matches = matches.map({ $0.replacingOccurrences(of: "\"", with: "") })

            if let match = matches.first {
                return Row(in: self, number: index + 1, key: match, value: "")
            }
            return nil
        })
    }
}
