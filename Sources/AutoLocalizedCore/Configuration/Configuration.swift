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

    public private(set) var disabledRules: [String] = [""]

    lazy var activeRules: [Rule] = {
        var rules: [Rule] = [DeadRule(), DuplicateKeyRule(), DuplicateValueRule(), MatchRule(), MissingRule()]
        rules.removeAll(where: { disabledRules.contains($0.name) })
        return rules
    }()

    enum CodingKeys: String, CodingKey {
        case supportedFileExtensions = "fileExtensions", excludedDirectories = "excluded", disabledRules
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        supportedFileExtensions = try container.decode([FileExtension].self, forKey: .supportedFileExtensions)
        excludedDirectories = try container.decodeIfPresent([String].self, forKey: .excludedDirectories) ?? []
        disabledRules = try container.decodeIfPresent([String].self, forKey: .disabledRules) ?? []
    }
}

