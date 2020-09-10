//
//  Validators.swift
//  
//
//  Created by Alex Pinhasov on 17/08/2020.
//

import Foundation

public class Validators {

    // MARK: - Properties

    private let fileFinder: FileFinder
    private let configuration: Configuration

    // MARK: - Init

    public init(for configuration: Configuration) {
        self.configuration = configuration
        fileFinder = FileFinder(with: configuration)
    }

    public func execute() -> [Violation] {
        var violations: [Violation] = []
        configuration.activeRules.forEach({
            violations.append(contentsOf: $0.validation(projectFiles: fileFinder.projectFiles, localizationFiles: fileFinder.localizableFiles))
        })
        return violations
    }
}
