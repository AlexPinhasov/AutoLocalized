//
//  File.swift
//  
//
//  Created by Alex Pinhasov on 27/08/2020.
//

import Foundation

extension String {
    public func withArguments(_ arguments: [String]) -> String {
        String(format: self, locale: Locale.current, arguments: arguments)
    }
}
