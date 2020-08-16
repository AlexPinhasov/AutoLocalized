//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 15/08/2020.
//

import Foundation

struct LocalizationStringsFile {
    let path: String
    let kv: [String: String]

    var keys: Set<String> {
        Set(Array(kv.keys))
    }
    init(path: String) {
        self.path = path
        self.kv = ContentParser.parse(path)
    }
}
