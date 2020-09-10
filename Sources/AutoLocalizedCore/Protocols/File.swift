//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 27/08/2020.
//

import Foundation

public protocol File {
    var path: String { get set }
    var rows: [Row] { get set }
    func parseRows() -> [Row]
}

extension File {
    /// Return all string rows in the file
    var allStringRows: [String] {
        guard let data = FileManager.default.contents(atPath: path),
            let content = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines)
            else { fatalError("Could not read from path: \(path)") }
        return content
    }

    /// Return the full content of the file
    var content: String {
        guard let data = FileManager.default.contents(atPath: path),
            let content = String(data: data, encoding: .utf8)
            else { fatalError("Could not read from path: \(path)") }
        return content
    }
}
