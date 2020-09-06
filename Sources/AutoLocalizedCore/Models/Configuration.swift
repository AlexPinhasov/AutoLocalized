//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 06/09/2020.
//

import Foundation
import Yams

public class Configuration {

    init() {
        let file = try? Yams.load(yaml: FileManager.default.currentDirectoryPath + "/.swiftlint.yml")
        print(file)
    }
}

