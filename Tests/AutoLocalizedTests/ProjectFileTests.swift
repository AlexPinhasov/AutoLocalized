import XCTest
import Foundation
@testable import AutoLocalizedCore

final class ProjectFileTests: XCTestCase {

    var englishLocalization: LocalizeFile!
    var projectFile: File!
    var validators: Validators!
    var configuration: Configuration!

    lazy var thisDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "")
    lazy var projectFilePath = thisDirectory + "Files/Person.swift"
    lazy var englishLocalizationFilePath = thisDirectory + "Localize/english.strings"

    override func setUpWithError() throws {
        if let yamlDefaultData = ConfigurationParser.baseYamlContent.data(using: .utf8) {
            configuration = ConfigurationParser.decode(data: yamlDefaultData)
            validators = Validators(for: configuration)
        }
        setupProjectFile()
        setupLocalizationFile()
    }

    override func tearDownWithError() throws {
        tearDownFile(for: englishLocalizationFilePath)
        tearDownFile(for: projectFilePath)
    }

    func testMissingKeys() {
        let violations = MissingRule().validation(projectFiles: [projectFile], localizationFiles: [englishLocalization])
        XCTAssert(violations.first?.rule is MissingRule, "Should throw an error for missing key")
    }

    func testDeadKeys() {
        let violations = DeadRule().validation(projectFiles: [projectFile], localizationFiles: [englishLocalization])
        XCTAssert(violations.filter({ $0.rule is DeadRule }).count == 2, "Should throw a warning for dead key")
    }
}

extension ProjectFileTests {
    private func setupProjectFile() {
        let fileContent =
        """
        import Foundation

        enum Person: String {
            case localizedString = "example_for_localize_key"
        }
        """
        let fileExtension = configuration.supportedFileExtensions.first(where: { $0.extension == "swift" })
        XCTAssertFalse(fileExtension == nil, "Cant find Swift file extension in yaml file")
        XCTAssertNoThrow(try fileContent.write(toFile: projectFilePath, atomically: true, encoding: .utf8))
        projectFile = ProjectFile(path: projectFilePath, fileExtension: fileExtension!)
    }

    private func setupLocalizationFile() {
        let localizationFileContent: String =
        """
        "candle" = "Candle";
        "base" = "Seconds Duplicate";
        """
        englishLocalization = setupFile(with: localizationFileContent, for: englishLocalizationFilePath)
    }
}
