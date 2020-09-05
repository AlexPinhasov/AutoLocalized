
<p align="center">
<img src="/Images/AutoLocalizedLogo.png" width="370" height="77">
</p>
<h4 align="center">A tool to manage localization in your project and show errors and/or warnings when needed.</h4>
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

AutoLocalized scans your project and search for your localization files and project files containing localized keys. By using Rules and Validation methods ensuring your keys and files are organized, clean, and always up to date with your work.
## Behind the scenes

<b>For every localization file found the following is executed:</b>
- Make sure each row has only 1 key and 1 value.
- Sort by keys.
- Validate no duplicate keys exist.
- Validate all localization files keys match.
- Validate all keys that are being used.

<b>For every project file found the following is executed:</b>
- If a localization key is used in the file but missing from the localization files, show a warning for the dead key.
##
To Do's:
- [x] ~~Add support for custom Rules and Validation methods.~~
- [x] ~~Add support for excluding directories.~~
- [ ] Identify a value is in the correct language of the localization file.
- [ ] Add Wiki
- [ ] Finish README.md


## Installation
<p align="center">
<img src="/Images/spi.png" width="100" height="100">
</p>
AutoLocalized is available through SPM (Swift Package Manager). To install it, simply follow the next steps.

1. <b>Add AutoLocalized as a dependecy using SPM:</b>
   - File -> Swift Packages -> Add Package Dependency

<p align="center">
<img src="/Images/SPM.png" width="730" height="434">
</p>

2. <b>Create a "New Run Script Phase" under you target in "Build Phases" tab and copy the script below.</b>

```Shell
SDKROOT=macosx

# Copy Configuration file
cp -f -v ${PROJECT_DIR}/${PROJECT_NAME}/AutoLocalizedConfiguration.swift ~/Library/Developer/Xcode/DerivedData/${PROJECT_NAME}-*/SourcePackages/checkouts/AutoLocalized/Sources/AutoLocalizedCore/SupportingFiles/AutoLocalizedConfiguration.swift

# Move to the AutoLocalized folder
cd ~/Library/Developer/Xcode/DerivedData/${PROJECT_NAME}-*/SourcePackages/checkouts/AutoLocalized

# Build and create a release 
swift run -c release

# Execute script
/.build/release/AutoLocalized ${PROJECT_DIR}/${PROJECT_NAME}

```

<p align="center">
<img src="/Images/bash.png">
</p>

3. <b>Copy the configuration file named "AutoLocalizedConfiguration.swift" and place it in your project directory.</b>
   - The file can be found here: 
     - Right click on the AutoLocalized Package and "Show in Finder"
     - Navigate to "Sources/AutoLocalizedCore/SupportingFiles" and copy from there.  
<p align="center">
<img src="/Images/configurationFile.png">
</p>  

     - The file must be copied here ${PROJECT_DIR}/${PROJECT_NAME}/AutoLocalizedConfiguration.swift
  
Optional Step but recommended   
4. <b>Link the file inside your project in Xcode to be able to modify it quickly and add new Rules/Validations/Supported File Extensions/Excluded Directories.</b>
   - Right-click on your selected folder in your project "Add files to {YourProjects}"
   - Find the new file we have just copied and select it (AutoLocalizedConfiguration.swift)
   
<p align="center">
<img src="/Images/fileExample.png">
</p>  

The configuration file is a gateway to the framework, by copying it to your project you are able to use as part of your other project files.
If you deleted something inside the file I will attach a "Template Files" section to always have a referencing point.

## Custom Rules And Validation Methods

1. <b>Inside the configuration file (AutoLocalizedConfiguration.swift) you can do the following things:</b>
  - Choose which files to read from using its extension (.swift, .xib, etc..) 
  - Exclude any directories the framework shouldn't search in.
  - Add new custom validation methods.
  - Add new Rules to have a visual representation in Xcode (Errors, Warnings) with readable context.
  
You are given the files collected and the localization files, after you have performed your validation return a [Violation] to see the errors/warnings.

<b>Example -> </b>

<p align="center">
<img src="/Images/configurationFileExample.png">
</p>  

2. If you only want to exclude a part of your code use
```swift
// autolocalized:disable
  {your code }
// autolocalized:enable
```

<p align="center">
<img src="/Images/autolocalized_disable.png">
</p>  

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


## Author

AlexPinhasov, alex5872205@gmail.com

## License

AutoLocalized is available under the MIT license. See the LICENSE file for more info.

