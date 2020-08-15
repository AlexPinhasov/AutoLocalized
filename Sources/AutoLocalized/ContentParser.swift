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
    static func parse(_ path: String) -> [String: String] {
        let content = contents(atPath: path)
        let trimmed = content
            .replacingOccurrences(of: "\n+", with: "", options: .regularExpression, range: nil)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let keys = regexFor("\"([^\"]*?)\"(?= =)", content: trimmed)
        let values = regexFor("(?<== )\"(.*?)\"(?=;)", content: trimmed)
        if keys.count != values.count { fatalError("Error parsing contents: Make sure all keys and values are in correct format without comments in file") }
        print("------------ Validating for duplicate keys: \(path) ------------")
        return zip(keys, values).reduce(into: [String: String]()) { results, keyValue in
            if results[keyValue.0] != nil {
                printPretty("error: Found duplicate key: \(keyValue.0) in file: \(path)")
                exit(EXIT_FAILURE)
            }
            results[keyValue.0] = keyValue.1
        }
    }
}
