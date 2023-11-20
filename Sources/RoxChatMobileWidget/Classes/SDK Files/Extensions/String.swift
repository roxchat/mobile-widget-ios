//
//  String.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2018 Roxchat. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    
    func MD5() -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    // MARK: - Properties
    var localized: String {
        return NSLocalizedString(self, bundle: WidgetAppDelegate.bundle, comment: "")
    }

    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    func substring(_ nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
    func addHttpsPrefix() -> String {
        if self.lowercased().hasPrefix("https://") || self.lowercased().hasPrefix("http://") {
            return self
        }
        return "https://" + self
    }
    
    static func unwarpOrEmpty(_ str: String?) -> String {
        if let str = str {
            return str
        }
        return ""
    }

    func oneLineString() -> Self {
        self.replacingOccurrences(of: "\n+", with: " ", options: .regularExpression)
    }
}

// MARK: -
extension String {
    
    // MARK: - Methods
    public func decodePercentEscapedLinksIfPresent() -> String {
        var convertedString = String()
        
        let checkingTypes: NSTextCheckingResult.CheckingType = [.link]
        if let linksDetector = try? NSDataDetector(types: checkingTypes.rawValue) {
            
            // swiftlint:disable legacy_constructor
            let linkMatches = linksDetector.matches(in: self,
                                                    range: NSMakeRange(0,
                                                                       self.count))
            // swiftlint:enable legacy_constructor
            if !linkMatches.isEmpty {
                var position = 0
                
                for linkMatch in linkMatches {
                    let linkMatchRange = linkMatch.range
                    if let url = linkMatch.url {
                        let beforeLinkStringSliceRangeStart = self.index(self.startIndex,
                                                                         offsetBy: position)
                        let beforeLinkStringSliceRangeEnd = self.index(self.startIndex,
                                                                       offsetBy: linkMatchRange.location)
                        let beforeLinkStringSlice = String(self[beforeLinkStringSliceRangeStart ..< beforeLinkStringSliceRangeEnd])
                        convertedString += beforeLinkStringSlice
                        
                        position = linkMatchRange.location + linkMatchRange.length
                        
                        let urlString = url.absoluteString.removingPercentEncoding
                        if let urlString = urlString {
                            convertedString += urlString
                        } else {
                            let linkStringSliceRangeStart = self.index(self.startIndex,
                                                                       offsetBy: linkMatchRange.location)
                            let linkStringSliceRangeEnd = self.index(self.startIndex,
                                                                     offsetBy: linkMatchRange.length)
                            convertedString += String(self[linkStringSliceRangeStart ..< linkStringSliceRangeEnd])
                        }
                    }
                }
                
                let closingStringSliceRangeStart = self.index(self.startIndex,
                                                              offsetBy: position)
                let closingStringSliceRangeEnd = self.index(self.startIndex,
                                                            offsetBy: self.count)
                let closingStringSlice = String(self[closingStringSliceRangeStart ..< closingStringSliceRangeEnd])
                convertedString += closingStringSlice
            } else {
                return self
            }
        }
        
        return convertedString
    }
    
    public func trimWhitespacesIn() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    public func validateURLString() -> Bool {
        for char in self {
            if char.isWhitespace || !char.isASCII {
                return false
            }
        }
        return NSURL(string: self) != nil
    }
    
}
