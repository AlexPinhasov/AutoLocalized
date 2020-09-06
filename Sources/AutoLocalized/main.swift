import Foundation
import AutoLocalizedCore

guard let projectPath = Array(CommandLine.arguments.dropFirst()).first else { fatalError("Missing project path as an argument")}
FileManager.default.changeCurrentDirectoryPath(projectPath)

let group = DispatchGroup()
group.enter()
var violations: [Violation] = []

// MARK: - Validation

DispatchQueue.global(qos: .background).async {
    let configuration = ConfigurationParser.decode()
    violations = Validators(for: configuration).execute()
    group.leave()
}

// MARK: - Completion

group.wait()
print(violations: violations)

print("Finished with \(violations.isEmpty ? "SUCCESS ✅" : "\(violations.count) violations ❌")")
violations.isEmpty ? exit(EXIT_SUCCESS) : exit(EXIT_FAILURE)
