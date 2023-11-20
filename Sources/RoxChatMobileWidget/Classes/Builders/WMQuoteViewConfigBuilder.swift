//
//  WMQuoteViewConfigBuilder.swift
//  RoxChat
//
//  
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

/**
 Quote View config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMQuoteViewConfigBuilder  {
    let quoteViewConfig = WMHelperInputViewConfig()
    
    public init() { }

    /**
     - returns:
     `WMHelperInputViewConfig` object.
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMHelperInputViewConfig {
        return quoteViewConfig
    }

    /**
     Sets view background сolor.
     - parameter backgroundColor:
     Color.
     - returns:
     `WMQuoteViewConfigBuilder` object with background сolor set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(backgroundColor: UIColor) -> Self {
        quoteViewConfig.backgroundColor = backgroundColor
        return self
    }

    /**
     Sets quote view background сolor.
     - parameter quoteViewBackgroundColor:
     Color.
     - returns:
     `WMQuoteViewConfigBuilder` object with quote view background сolor set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(quoteViewBackgroundColor: UIColor) -> Self {
        quoteViewConfig.quoteViewBackgroundColor = quoteViewBackgroundColor
        return self
    }

    /**
     Sets quote view text color.
     - parameter quoteTextColor:
     Text color.
     - returns:
     `WMQuoteViewConfigBuilder` object with quote view text color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(quoteTextColor: UIColor) -> Self {
        quoteViewConfig.quoteTextColor = quoteTextColor
        return self
    }

    /**
     Sets quote view author text color.
     - parameter authorTextColor:
     Color.
     - returns:
     `WMQuoteViewConfigBuilder` object with author text color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(authorTextColor: UIColor) -> Self {
        quoteViewConfig.authorTextColor = authorTextColor
        return self
    }

    /**
     Sets quote text font.
     - parameter quoteTextFont:
     Text font.
     - returns:
     `WMQuoteViewConfigBuilder` object with quote text font set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(quoteTextFont: UIFont) -> Self {
        quoteViewConfig.quoteTextFont = quoteTextFont
        return self
    }

    /**
     Sets quote view author text font.
     - parameter authorTextFont:
     Text font.
     - returns:
     `WMQuoteViewConfigBuilder` object with author text font set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(authorTextFont: UIFont) -> Self {
        quoteViewConfig.authorTextFont = authorTextFont
        return self
    }

    /**
     Sets quote view line color.
     - parameter quoteLineColor:
     Line color.
     - returns:
     `WMQuoteViewConfigBuilder` object with quote view line color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(quoteLineColor: UIColor) -> Self {
        quoteViewConfig.quoteLineColor = quoteLineColor
        return self
    }

    /**
     Sets quote view height.
     - parameter navigationBarConfig:
     Quote view height.
     - returns:
     `WMQuoteViewConfigBuilder` object with quote view height set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(height: CGFloat) -> Self {
        quoteViewConfig.height = height
        return self
    }
}
