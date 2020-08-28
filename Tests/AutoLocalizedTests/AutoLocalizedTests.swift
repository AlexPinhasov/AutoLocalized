import XCTest
@testable import AutoLocalizedCore

final class AutoLocalizedTests: XCTestCase {
    func testExample() {
        FileManager.default.changeCurrentDirectoryPath("/Users/alexpinhasov/Documents/GitHub/AutoLocalized/Tests/AutoLocalizedTests/")
        print(FileManager.default.currentDirectoryPath)
        let test = LocalizeFile(path: "Localize/english.strings")
        print(test.rows.first?.keyValue)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
