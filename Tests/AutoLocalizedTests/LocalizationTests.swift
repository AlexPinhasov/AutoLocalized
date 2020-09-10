import XCTest
import Foundation
@testable import AutoLocalizedCore

final class LocalizationTests: XCTestCase {

    var englishLocalization: LocalizeFile!
    var spanishLocalization: LocalizeFile!
    var validators: Validators!
    var configuration: Configuration!

    lazy var thisDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "")
    lazy var englishLocalizationFilePath = thisDirectory + "Localize/english.strings"
    lazy var spanishLocalizationFilePath = thisDirectory + "Localize/spanish.strings"

    static var allTests = [
        ("testLocalizationFileSortedCorrectly", testLocalizationFileSortedCorrectly),
        ("testMoreThenOneKeyViolation", testMoreThenOneKeyViolation),
        ("testAllLocalizationFilesKeysMatch", testAllLocalizationFilesKeysMatch),
        ("testAllLocalizationFilesKeysDontMatch", testAllLocalizationFilesKeysDontMatch)
    ]

    override func setUpWithError() throws {
        if let yamlDefaultData = ConfigurationParser.baseYamlContent.data(using: .utf8) {
            configuration = ConfigurationParser.decode(data: yamlDefaultData)
            validators = Validators(for: configuration)
        }
    }

    override func tearDownWithError() throws {
        tearDownFile(for: englishLocalizationFilePath)
        tearDownFile(for: spanishLocalizationFilePath)
    }

    // MARK: Testing

    func testLocalizationFileSortedCorrectly() {
        let content: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "base" = "No";
        """
        englishLocalization = setupFile(with: content, for: englishLocalizationFilePath)
        XCTAssertTrue(englishLocalization.rows.compactMap({ $0.key }).isAscending(), "Localization file are not sorted")
    }

    func testMoreThenOneKeyViolation() {
        let content: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "about" = "Duplicate";
            "base" = "No";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupFile(with: content, for: englishLocalizationFilePath)
        let violations = DuplicateKeyRule().validation(projectFiles: [], localizationFiles: [englishLocalization])
        XCTAssert(violations.filter({ $0.rule is DuplicateKeyRule }).count == 4, "No Duplicates keys found")
    }

    func testSameValueDifferentKeysViolation() {
        let content: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "title" = "Yes";
            "base" = "No";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupFile(with: content, for: englishLocalizationFilePath)
        let violations = DuplicateValueRule().validation(projectFiles: [], localizationFiles: [englishLocalization])
        XCTAssert(violations.filter({ $0.rule is DuplicateValueRule }).count == 2, "No Duplicates values found")
    }

    func testAllLocalizationFilesKeysMatch() {
        let content: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupFile(with: content, for: englishLocalizationFilePath)
        spanishLocalization = setupFile(with: content, for: spanishLocalizationFilePath)
        let violations = MatchRule().validation(projectFiles: [], localizationFiles: [englishLocalization, spanishLocalization])
        XCTAssert(violations.filter({ $0.rule is MatchRule }).isEmpty, "Localization files dont match")
    }

    func testAllLocalizationFilesKeysDontMatch() {
        let englishContent: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "base" = "Seconds Duplicate";
        """

        let spanishContent: String =
        """
            "candle" = "Candle";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupFile(with: englishContent, for: englishLocalizationFilePath)
        spanishLocalization = setupFile(with: spanishContent, for: spanishLocalizationFilePath)
        let violations = MatchRule().validation(projectFiles: [], localizationFiles: [englishLocalization, spanishLocalization])
        XCTAssert(!violations.filter({ $0.rule is MatchRule }).isEmpty, "Localization files dont match")
    }


}

extension XCTestCase {
    func setupFile(with content: String, for path: String) -> LocalizeFile {
        XCTAssertNoThrow(try content.write(toFile: path, atomically: true, encoding: .utf8))
        return LocalizeFile(path: path)
    }

    func tearDownFile(for path: String) {
        XCTAssertNoThrow(try "".write(toFile: path, atomically: true, encoding: .utf8))
    }
}
