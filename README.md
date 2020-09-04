
<p align="center">
<img src="/Images/AutoLocalizedLogo.png" width="370" height="77">
</p>

<h4 align="center">A tool to manage localization in your project</h4>

<p align="center">
  <img alt="Platform" src="https://img.shields.io/cocoapods/p/EqualableGeneric.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Alex Pinhasov-blue.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-5.0%2B-orange.svg">
</p>

<p align="center">
  <a href="#example">Example</a> •
  <a href="#installation">Installation</a> •
  <a href="#author">Author</a> •
  <a href="#license">License</a>
</p>

## Example

## Template Files
AutoLocalizedConfiguration file:

```swift
///
/// Use this configuration file to manage AutoLocalized search files and directories
///

import AutoLocalizedCore

public enum Configurations {

    /// What extension do you want to support.
    public static let supportedFileExtensions = ["swift", "xib", "storyboard"]

    /// Exclude directories you want to ignore.
    public static let excludedDirectories = ["AutoLocalizedConfiguration.swift"]
}

/// Create custom validators for unique cases

enum CustomValidators {

    /// Returns a list of violations found
    ///
    /// - Parameters:
    ///   - projectFiles: Given to you by the framework
    ///   - localizeFiles: Given to you by the framework
    /// - Returns: list of Violations
    static func genericValidator(projectFiles: [AutoLocalizedCore.File], localizeFiles: [LocalizeFile]) -> [Violation] {
        return []
    }

    // MARK: - Validation Methods

}

/// Create your own rules

```

Example -> 

![GitHub Logo](/Images/configurationFileExample.png)


## Installation

AutoLocalized is available through SPM (Swift Package Manager). To install
it, simply add the repository, File -> Swift Packages -> Add Package Dependency

## Author

AlexPinhasov, alex5872205@gmail.com

## License

AutoLocalized is available under the MIT license. See the LICENSE file for more info.

