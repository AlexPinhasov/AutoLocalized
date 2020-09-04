
<p align="center">
<img src="/Images/AutoLocalizedLogo.png" width="370" height="77">
</p>
<h4 align="center">A tool to manage localization in your project</h4>
<p align="center">
<img src="/Images/Example.png">
</p>

<p align="center">
  <img alt="Platform" src="https://img.shields.io/cocoapods/p/EqualableGeneric.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Alex Pinhasov-blue.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-5.0%2B-orange.svg">
</p>

<p align="center">
  <a href="#behindthescenes">Behind the scenes</a> •
  <a href="#installation">Installation</a> •
  <a href="#author">Author</a> •
  <a href="#license">License</a>
</p>

AutoLocalized scans your project and search for your localization files and project files containg localized keys.
By using Rules and Validation methods ensuring your keys and files are orgnaized, clean and always up to do with your work.
## Behind the scenes

For every localization file found the folowing is executed:
- Make sure each row has only 1 key and 1 value.
- Sort by keys.
- Validate no duplicate keys exist.
- Validate all localization files keys match.
- Validate all keys are being used.

For every project file found the following is executed:
- If a localization key is used in the file but missing from the localization files, show an warning for dead key.
##
To Do's:
- [x] ~~Add support for custom Rules and Validation methods.~~
- [x] ~~Add support for excluding directories.~~
- [ ] Identify a value is in the correct language of the localziation file.
- [ ] Reduce build time. (Copy configuration file only when a change is made, find a way caching the executable)


## Installation

AutoLocalized is available through SPM (Swift Package Manager). To install
it, simply add the repository.

File -> Swift Packages -> Add Package Dependency

Copy git repository path into the search field.

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


## Author

AlexPinhasov, alex5872205@gmail.com

## License

AutoLocalized is available under the MIT license. See the LICENSE file for more info.

