import XCTest
import Foundation
@testable import AutoLocalizedCore

final class AutoLocalizedTests: XCTestCase {

    var englishLocalization: LocalizeFile!
    var spanishLocalization: LocalizeFile!

    lazy var thisDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "")
    lazy var englishLocalizationFilePath = thisDirectory + "Localize/english.strings"

    static var allTests = [
        ("testLocalizationFileSortedCorrectly", testLocalizationFileSortedCorrectly),
    ]

    override func setUpWithError() throws {
        setupEnglishLocalizeFile()
    }

    override func tearDownWithError() throws {
        tearDownEnglishLocalizeFile()
    }

    // MARK: Testing

    func testLocalizationFileSortedCorrectly() {
        XCTAssertTrue(englishLocalization.rows.compactMap({ $0.key }).isAscending(), "Localization file are not sorted")
    }

    func testMoreThenOneKey() {
        
    }
}

extension AutoLocalizedTests {
    private func setupEnglishLocalizeFile() {
        let englishContent: String =
        """
            "candle" = "Candle";
            "about" = "Yes";
            "base" = "No";
        """

        XCTAssertNoThrow(try englishContent.write(toFile: englishLocalizationFilePath, atomically: true, encoding: .utf8))
        englishLocalization = LocalizeFile(path: englishLocalizationFilePath)
    }

    private func tearDownEnglishLocalizeFile() {
        XCTAssertNoThrow(try "".write(toFile: englishLocalizationFilePath, atomically: true, encoding: .utf8))
    }
}
