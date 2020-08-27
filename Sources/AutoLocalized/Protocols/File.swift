//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 27/08/2020.
//

import Foundation

protocol File {
    var path: String { get set }
    var rows: [Row] { get set }
    func parseRows() -> [Row]
}

extension File {
    /// Reads rows in path
    ///
    /// - Parameter path: path of file
    /// - Returns: all rows in file
    var allStringRows: [String] {
        guard let data = fileManager.contents(atPath: path),
            let content = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines)
            else { fatalError("Could not read from path: \(path)") }
        return content
    }

    /// Reads contents in path
    ///
    /// - Parameter path: path of file
    /// - Returns: content in file
    var content: String {
        guard let data = fileManager.contents(atPath: path),
            let content = String(data: data, encoding: .utf8)
            else { fatalError("Could not read from path: \(path)") }
        return content
    }
}
