//
//  WMNavigationBarConfigBuilder.swift
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
 Navigationv bar config.
 - copyright:
 2023 Roxchat
 */
public class WMNavigationBarConfigBuilder {
    var navigationBarConfig = WMNavigationBarConfig()

    public init() { }

    /**
     - returns:
     `WMNavigationBarConfig` object.
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMNavigationBarConfig {
        return navigationBarConfig
    }

    /**
     Sets navigation bar background color online state.
     - parameter backgroundColorOnlineState:
     Color.
     - returns:
     `WMNavigationBarConfigBuilder` object with background color online state set.
     - copyright:
     2023 Roxchat
     */
    public func set(backgroundColorOnlineState: UIColor) -> Self {
        navigationBarConfig.backgroundColorOnlineState = backgroundColorOnlineState
        return self
    }

    /**
     Sets navigation bar background color offline state.
     - parameter backgroundColorOfflineState:
     Color.
     - returns:
     `WMNavigationBarConfigBuilder` object with background color offline state set.
     - copyright:
     2023 Roxchat
     */
    public func set(backgroundColorOfflineState: UIColor) -> Self {
        navigationBarConfig.backgroundColorOfflineState = backgroundColorOfflineState
        return self
    }
    
    /**
     Sets navigation bar text color online state.
     - parameter textColorOnlineState:
     Color.
     - returns:
     `WMNavigationBarConfigBuilder` object with text color online state set.
     - copyright:
     2023 Roxchat
     */
    public func set(textColorOnlineState: UIColor) -> Self {
        navigationBarConfig.textColorOnlineState = textColorOnlineState
        return self
    }

    /**
     Sets navigation bar text color offline state.
     - parameter textColorOfflineState:
     Color.
     - returns:
     `WMNavigationBarConfigBuilder` object with text color offline state set.
     - copyright:
     2023 Roxchat
     */
    public func set(textColorOfflineState: UIColor) -> Self {
        navigationBarConfig.textColorOfflineState = textColorOfflineState
        return self
    }

    /**
     Sets navigation bar right bar button image.
     - parameter rightBarButtonImage:
     image.
     - returns:
     `WMNavigationBarConfigBuilder` object with right bar button image set.
     - copyright:
     2023 Roxchat
     */
    public func set(rightBarButtonImage: UIImage) -> Self {
        navigationBarConfig.rightBarButtonImage = rightBarButtonImage
        return self
    }
}
