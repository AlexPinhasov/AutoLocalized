#!/usr/bin/xcrun --sdk macosx swift

import Foundation
import Darwin

// We drop the first argument, which is the script execution path.
let arguments: [String] = Array(CommandLine.arguments.dropFirst())

guard let currentPath: String = arguments.first else { exit(EXIT_FAILURE) }

let fileManager = FileManager.default
FileManager.default.changeCurrentDirectoryPath(currentPath)

/// List of files in currentPath - recursive
var pathFiles: [String] = {
    guard let enumerator = fileManager.enumerator(atPath: currentPath),
        let files = enumerator.allObjects as? [String]
        else { fatalError("Could not locate files in path directory: \(currentPath)") }
    return files
}()

/// List of localizable files - not including Localizable files in the Pods
var localizableFiles: [String] = {
    return pathFiles.filter { $0.hasSuffix("Localize.strings") && !$0.contains("Pods") }
}()

/// List of executable files
var executableFiles: [String] = {
    return pathFiles.filter { (!$0.localizedCaseInsensitiveContains("test") && NSString(string: $0).pathExtension == "swift"  && !NSString(string: $0).contains("Pods")) && NSString(string: $0).contains("Selina/Localization/Enums") || NSString(string: $0).pathExtension == "xib" || NSString(string: $0).pathExtension == "storyboard"}
}()

/// Reads contents in path
///
/// - Parameter path: path of file
/// - Returns: content in file
func contents(atPath path: String) -> String {
    guard let data = fileManager.contents(atPath: path),
        let content = String(data: data, encoding: .utf8)
        else { fatalError("Could not read from path: \(path)") }
    return content
}

/// Returns a list of strings that match regex pattern from content
///
/// - Parameters:
///   - pattern: regex pattern
///   - content: content to match
/// - Returns: list of results
func regexFor(_ pattern: String, content: String, rangeIndex: Int = 0) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    return matches.map {
        guard let range = Range($0.range(at: rangeIndex), in: content) else { fatalError("Incorrect range match") }
        return String(content[range])
    }
}

func create() -> [LocalizationStringsFile] {
    return localizableFiles.map(LocalizationStringsFile.init(path:))
}

/// Writes back to localizable file with sorted keys and removed whitespaces and new lines
func clean(stringFiles: [LocalizationStringsFile]) {
    stringFiles.forEach({ localizeFile in
        print("------------ 🧮 Sort and remove whitespaces: \(localizeFile.path) ------------")
        let content = kv.keys.sorted().map { "\($0) = \(kv[$0]!);" }.joined(separator: "\n")
        do {
            try content.write(toFile: localizeFile.path, atomically: true, encoding: .utf8)
        } catch {
            print("error: ------------ ❌ Error: \(error) ------------")
            exit(EXIT_FAILURE)
        }
    })
}

///
///
/// - Returns: A list of LocalizationCodeFile - contains path of file and all keys in it
func localizedStringsInCode() -> [LocalizationCodeFile] {
    return executableFiles.compactMap {
        let content = contents(atPath: $0)
        if $0.contains("xib") || $0.contains("storyboard") {
            var matches = regexFor("(text|title|value|placeholder)=\"([a-z|_]*?)\"", content: content, rangeIndex: 2)
            matches.removeAll(where: { $0 == "" || $0 == "\"\"" })
            matches = matches.map({ $0.replacingOccurrences(of: "\"", with: "") })
            return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches))
        } else {
            var matches = regexFor("(case|return|static let).*?\"([a-z|_]*?)\"", content: content, rangeIndex: 2)
            matches.removeAll(where: { $0 == "" || $0 == "\"\"" })
            matches = matches.map({ $0.replacingOccurrences(of: "\"", with: "") })
            return matches.isEmpty ? nil : LocalizationCodeFile(path: $0, keys: Set(matches))
        }
    }
}

/// Throws error is ALL localizable files does not have matching keys
///
/// - Parameter files: list of localizable files to validate
func validateMatchKeys(_ files: [LocalizationStringsFile]) {
    print("------------ 📚 Validating keys match in all localizable files ------------")
    guard let base = files.first, files.count > 1 else {
        print("------------ 📚 Only 1 localize file found ------------")
        return
    }
    let files = Array(files.dropFirst())
    files.forEach {
        if let extraKey = Set(base.keys).symmetricDifference($0.keys).first {
            let incorrectFile = $0.keys.contains(extraKey) ? $0 : base
            printPretty("error: Found missing key: \(extraKey) in file: \(incorrectFile.path)")
            exit(EXIT_FAILURE)
        }
    }
}

/// Throws error if localizable files are missing keys
///
/// - Parameters:
///   - codeFiles: Array of LocalizationCodeFile
///   - localizationFiles: Array of LocalizableStringFiles
func validateMissingKeys(_ codeFiles: [LocalizationCodeFile], localizationFiles: [LocalizationStringsFile]) {
    print("------------ Checking for missing keys -----------")
    guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
    let baseKeys = Set(baseFile.keys.map({ $0.replacingOccurrences(of: "\"", with: "") }))
    codeFiles.forEach {
        let keysToCompare = $0.keys
        let extraKeys = keysToCompare.subtracting(baseKeys)
        if !extraKeys.isEmpty {
            printPretty("error: Found keys in code: \(extraKeys) from \($0.path), missing in strings file ")
            exit(EXIT_FAILURE)
        }
    }
}

/// Throws warning if keys exist in localizable file but are not being used
///
/// - Parameters:
///   - codeFiles: Array of LocalizationCodeFile
///   - localizationFiles: Array of LocalizableStringFiles
func validateDeadKeys(_ codeFiles: [LocalizationCodeFile], localizationFiles: [LocalizationStringsFile]) {
    print("------------ Checking for any dead keys in localizable file -----------")
    guard let baseFile = localizationFiles.first else { fatalError("Could not locate base localization file") }
    let baseKeys = Set(baseFile.keys.map({ $0.replacingOccurrences(of: "\"", with: "")}))
    var allCodeFileKeys = codeFiles.flatMap { $0.keys }
    allCodeFileKeys = (NSOrderedSet(array: allCodeFileKeys)).array as! [String]
    let deadKeys = baseKeys.subtracting(allCodeFileKeys)
    if !deadKeys.isEmpty {
        printPretty("warning: \(deadKeys) - Suggest cleaning dead keys")
    }
}

func printPretty(_ string: String) {
    print(string.replacingOccurrences(of: "\\", with: ""))
}

let stringFiles = create()
validateMatchKeys(stringFiles)
clean(stringFiles)

let codeFiles = localizedStringsInCode()
validateMissingKeys(codeFiles, localizationFiles: stringFiles)
validateDeadKeys(codeFiles, localizationFiles: stringFiles)

print("------------ SUCCESS ------------")
exit(EXIT_SUCCESS)

