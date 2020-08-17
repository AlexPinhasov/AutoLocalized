//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 15/08/2020.
//

import Foundation

class LocalizationStringsFile: File {
    init(path: String) {
        super.init(path: path, rows: [])
        self.path = path
        self.rows = ContentParser.parse(path)
    }
}
