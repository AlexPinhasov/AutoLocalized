///
/// Use this configuration file to manage AutoLocalized search files and directories
///

import Foundation
import Yams

public enum Configurations {

    /// What extension to you want to support.
    public static let supportedFileExtensions = ["swift", "xib", "storyboard"]

    /// Exclude directories you want to ignore.
    public static let excludedDirectories = [""]
}

enum CustomValidators {
    static func genericValidator(projectFiles: [File], localizeFiles: [LocalizeFile]) -> [Violation] {
        return []
    }
}
