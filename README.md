
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

## Installation
<p align="center">
<img src="/Images/spi.png" width="100" height="100">
</p>
AutoLocalized is available through SPM (Swift Package Manager). To install it, simply follow the next steps.

1. <b>Add AutoLocalized as a dependecy using SPM:</b>
   - File -> Swift Packages -> Add Package Dependency

<p align="left">
<img src="/Images/SPM.png" width="730" height="434">
</p>

2. <b>Create a "New Run Script Phase" under you target in "Build Phases" tab and copy the script below.</b>

```Shell
SDKROOT=macosx

cd ~/Library/Developer/Xcode/DerivedData/${PROJECT_NAME}-*/SourcePackages/checkouts/AutoLocalized
swift run -c release AutoLocalized ${PROJECT_DIR}/${PROJECT_NAME}

```

3. <b>Build the project, in your project file you will find a ".autolocalized.yml" configuration file.</b>
* If you get an "error:invalid Access" error after building, just build agian it will go away. (SPM bug)

## Configuration (.autolocalized.yml)

Configure AutoLocalized by adding a .autolocalized.yml file in your project file or building the project once, the framework can create a file when non is found. The following parameters can be configured:

fileExtensions: 
  - extension to support
  - regex to search by keys
  - match_index what index in regex match to select
  
excluded: what directories to ignore        
  - Path
  
disabledRules: what rules to ignore        
  - duplicateValue
```yaml
fileExtensions: # extensions to support (.swift, .xib...).
  - extension: swift
    regex: "(case|return|static let).*?\"([a-z|_]*?)\""
    match_index: 2
  - extension: xib
    regex: "(text|title|value|placeholder)=\"([a-z|_]*?)\""
    match_index: 2
  - extension: storyboard
    regex: "(text|title|value|placeholder)=\"([a-z|_]*?)\""
    match_index: 2
excluded: # paths to ignore.
  - Attribution/
  - Operations/
  - Localization/LocalizableProtocol
disabledRules: # ignore rules by specefing their names
  - duplicateValue
```
  
## Disable Auto localized

If you only want to exclude a part of your code use
```swift
// autolocalized:disable
  {your code }
// autolocalized:enable
```

<p align="left">
<img src="/Images/autolocalized_disable.png">
</p>  

## Output

In your "Build report" in Xcode, you will see all the files that were found using your <b>.autolocalized.yml</b> configuration, separated by file type. In addition, you will see the number of keys in that files and the keys.

<p align="left">
<img src="/Images/Terminal output.png">
</p>  

## Author

AlexPinhasov, alexp.software@gmail.com

## License

AutoLocalized is available under the MIT license. See the LICENSE file for more info.

