//
//  File 2.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

class File {
    var path: String
    var rows: [Row]

    init(path: String, rows: [Row]) {
        self.path = path
        self.rows = rows
    }

    /// Reads contents in path
    ///
    /// - Parameter path: path of file
    /// - Returns: content in file
    lazy var allStringRows: [String] = {
        guard let data = fileManager.contents(atPath: path),
            let content = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines)
            else { fatalError("Could not read from path: \(path)") }
        return content
    }()

    /// Reads contents in path
    ///
    /// - Parameter path: path of file
    /// - Returns: content in file
    lazy var content: String = {
        guard let data = fileManager.contents(atPath: path), let content = String(data: data, encoding: .utf8)
            else { fatalError("Could not read from path: \(path)") }
        return content
    }()
}
