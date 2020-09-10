//
//  Rule.swift
//  
//
//  Created by Alex Pinhasov on 31/08/2020.
//

public protocol Rule {
    /// Rule name
    var name: String { get set }

    /// Row effected by this rule
    var row: Row? { get set }

    // Rule description
    var description: String { get set }

    /// Rule output string
    var errorString: String { get }

    /// A validation methods for the rule
    ///
    /// - Parameters:
    ///   - projectFiles: Files in project to iterate
    ///   - localizationFiles: LocalizableFiles in project
    func validation(projectFiles: [File], localizationFiles: [File]) -> [Violation]
}
