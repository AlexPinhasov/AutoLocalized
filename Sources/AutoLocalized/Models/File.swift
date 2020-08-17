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
}
