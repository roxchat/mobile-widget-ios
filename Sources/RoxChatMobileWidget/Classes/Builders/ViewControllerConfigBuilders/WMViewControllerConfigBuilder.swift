//
//  WMViewControllerConfigBuilder.swift
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
 Roxchat view controller config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMViewControllerConfigBuilder {
    let viewControllerConfig = WMViewControllerConfig()

    public init() { }

    /**
     - returns:
     `WMViewControllerConfig` object.
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMViewControllerConfig {
        return viewControllerConfig
    }

    /**
     Sets navigation bar config.
     - parameter navigationBarConfig:
     Navigation bar config.
     - returns:
     `WMViewControllerConfigBuilder` object with navigation bar config set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(navigationBarConfig: WMNavigationBarConfig) -> Self {
        viewControllerConfig.navigationBarConfig = navigationBarConfig
        return self
    }

    /**
     Sets background color.
     - parameter backgroundColor:
     Background color.
     - returns:
     `WMViewControllerConfigBuilder` object with background color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(backgroundColor: UIColor) -> Self {
        viewControllerConfig.backgroundColor = backgroundColor
        return self
    }
}
