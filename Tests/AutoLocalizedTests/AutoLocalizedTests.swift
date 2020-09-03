import XCTest
import Foundation
@testable import AutoLocalizedCore

final class AutoLocalizedTests: XCTestCase {

    var englishLocalization: LocalizeFile!
    var spanishLocalization: LocalizeFile!
    var validators = Validators()

    lazy var thisDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "")
    lazy var englishLocalizationFilePath = thisDirectory + "Localize/english.strings"
    lazy var spanishLocalizationFilePath = thisDirectory + "Localize/spanish.strings"

    static var allTests = [
        ("testLocalizationFileSortedCorrectly", testLocalizationFileSortedCorrectly),
    ]

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        tearDownLocalizeFile(for: englishLocalizationFilePath)
        tearDownLocalizeFile(for: spanishLocalizationFilePath)
    }

    // MARK: Testing

    func testLocalizationFileSortedCorrectly() {
        let content: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "base" = "No";
        """
        englishLocalization = setupLocalizeFile(with: content, for: englishLocalizationFilePath)
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
        englishLocalization = setupLocalizeFile(with: content, for: englishLocalizationFilePath)
        let violations = validators.validateDuplicateKeys(in: [englishLocalization])
        XCTAssert(violations.filter({ $0.rule is MatchRule }).count == 4, "No Duplicates found")
    }

    func testAllLocalizationFilesKeysMatch() {
        let content: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupLocalizeFile(with: content, for: englishLocalizationFilePath)
        spanishLocalization = setupLocalizeFile(with: content, for: spanishLocalizationFilePath)
        let violations = validators.validateLocalizationKeysMatch(in: [englishLocalization, spanishLocalization])
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
        englishLocalization = setupLocalizeFile(with: englishContent, for: englishLocalizationFilePath)
        spanishLocalization = setupLocalizeFile(with: spanishContent, for: spanishLocalizationFilePath)
        let violations = validators.validateLocalizationKeysMatch(in: [englishLocalization, spanishLocalization])
        XCTAssert(!violations.filter({ $0.rule is MatchRule }).isEmpty, "Localization files dont match")
    }

    func testMissingKeys() {
        let content: String =
        """
            "candle" = "Candle";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupLocalizeFile(with: content, for: englishLocalizationFilePath)
        let file = ProjectFile(path: thisDirectory + "Files/File.swift")
        let violations = validators.validateMissingKeys(from: [file], in: [englishLocalization])
        XCTAssert(violations.filter({ $0.rule is MissingRule }).count == 1, "Should throw an error for missing key")
    }

    func testDeadKeys() {
        let content: String =
        """
            "candle" = "Candle";
            "base" = "Seconds Duplicate";
        """
        englishLocalization = setupLocalizeFile(with: content, for: englishLocalizationFilePath)
        let file = ProjectFile(path: thisDirectory + "Files/File.swift")
        let violations = validators.validateDeadKeys(from: [file], in: [englishLocalization])
        XCTAssert(violations.filter({ $0.rule is DeadRule }).count == 2, "Should throw a warning for dead key")
    }
}

extension AutoLocalizedTests {
    private func setupLocalizeFile(with content: String, for path: String) -> LocalizeFile {
        XCTAssertNoThrow(try content.write(toFile: path, atomically: true, encoding: .utf8))
        return LocalizeFile(path: path)
    }

    private func tearDownLocalizeFile(for path: String) {
        XCTAssertNoThrow(try "".write(toFile: path, atomically: true, encoding: .utf8))
    }
}
