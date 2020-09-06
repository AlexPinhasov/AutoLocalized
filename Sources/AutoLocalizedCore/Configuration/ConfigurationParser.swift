//
//  ConfigurationParser.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation
import Yams

public class ConfigurationParser {

    static let baseYamlContent =
    """
    fileExtensions: # extensions to support (.swift, .xib...).
      - extension: swift
        regex: "\\"([a-z|_]*?)\\""
        match_index: 1
    excluded: # paths to ignore.
      -
    """

    public static func decode() -> Configuration {
        do {
            guard let readYamlData = readYamlData else { fatalError("Cant decode yaml file") }
            return try YAMLDecoder().decode(Configuration.self, from: readYamlData)
        } catch {
            fatalError("Cant decode yaml file")
        }
    }

    private static var readYamlData: Data? {
        let projectPath = NSString(string: FileManager.default.currentDirectoryPath).pathComponents.dropLast().joined(separator: "/")
        if let data = FileManager.default.contents(atPath: "\(projectPath)/.autolocalized.yml"){
            return data
        }
        else if let yamlDefaultData = baseYamlContent.data(using: .utf8) {
            FileManager.default.createFile(atPath: "\(projectPath)/.autolocalized.yml", contents: yamlDefaultData, attributes: nil)
            return yamlDefaultData
        }
        return nil
    }
}
