//
//  SupportingMethods.swift
//
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

public func print(violation: [Violation]) {
    violation.forEach({ violation in
        if let file = violation.rule.row.file {
            let filePathAndLine: String = "\(FileManager.default.currentDirectoryPath)/\(file.path):\(violation.rule.row.number)"
            print("\(filePathAndLine): \(violation.rawValue): \(violation.rule.errorString)")
        }
    })
}

/// Returns a list of strings that match regex pattern from content
///
/// - Parameters:
///   - pattern: regex pattern
///   - content: content to match
/// - Returns: list of results
public func regexFor(_ pattern: String, content: String, rangeIndex: Int = 0) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    return matches.map {
        guard let range = Range($0.range(at: rangeIndex), in: content) else { fatalError("Incorrect range match") }
        return String(content[range])
    }
}
