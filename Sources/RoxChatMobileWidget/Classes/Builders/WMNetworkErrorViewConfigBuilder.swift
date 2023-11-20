//
//  WMNetworkErrorViewConfigBuilder.swift
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
 Network error view config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMNetworkErrorViewConfigBuilder {
    var config = WMNetworkErrorViewConfig()

    public init() { }

    /**
     - returns:
     `WMNetworkErrorViewConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMNetworkErrorViewConfig {
        return config
    }

    /**
     Sets network error view image.
     - parameter image:
     Network error image.
     - returns:
     `WMNetworkErrorViewConfigBuilder` object with image set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(image: UIImage) -> WMNetworkErrorViewConfigBuilder {
        config.image = image
        return self
    }

    /**
     Sets network error view text.
     - parameter text:
     Network error view text.
     - returns:
     `WMNetworkErrorViewConfigBuilder` object with text set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(text: String) -> WMNetworkErrorViewConfigBuilder {
        config.text = text
        return self
    }

    /**
     Sets network error view background color.
     - parameter backgroundColor:
     Network error view background color.
     - returns:
     `WMNetworkErrorViewConfigBuilder` object with background color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(backgroundColor: UIColor) -> WMNetworkErrorViewConfigBuilder {
        config.backgroundColor = backgroundColor
        return self
    }

    /**
     Sets network error view text color.
     - parameter textColor:
     Network error view text color.
     - returns:
     `WMNetworkErrorViewConfigBuilder` object with text color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(textColor: UIColor) -> WMNetworkErrorViewConfigBuilder {
        config.textColor = textColor
        return self
    }
}
