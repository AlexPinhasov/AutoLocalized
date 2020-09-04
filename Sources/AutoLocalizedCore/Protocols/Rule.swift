//
//  Rule.swift
//  
//
//  Created by Alex Pinhasov on 31/08/2020.
//

public protocol Rule {
    var name: String { get set }
    var row: Row { get set }
    var description: String { get set }
    var errorString: String { get }
}
