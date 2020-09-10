//
//  FileExtension.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public class FileExtension: Codable {

    /// Extension name
    public var `extension`: String

    /// What is the regex to search keys by in this extension
    public var regex: String

    /// The correct match index for the regex provided
    public var matchIndex: Int

    enum CodingKeys: String, CodingKey {
        case matchIndex = "match_index", `extension`, regex
    }
}
