//
//  Configuration.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation

public class Configuration: Codable {

    /// What extension to you want to support.
    public private(set) var supportedFileExtensions: [FileExtension] = []

    /// Exclude directories you want to ignore.
    public private(set) var excludedDirectories: [String] = [""]

    enum CodingKeys: String, CodingKey {
        case supportedFileExtensions = "fileExtensions", excludedDirectories = "excluded"
    }
}

