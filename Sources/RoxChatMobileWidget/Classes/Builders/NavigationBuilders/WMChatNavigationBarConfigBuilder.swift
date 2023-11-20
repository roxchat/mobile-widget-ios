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

import UIKit

/**
 Chat Navigation Bar config.
 - copyright:
 2023 Roxchat
 */
public class WMChatNavigationBarConfigBuilder: WMNavigationBarConfigBuilder {
    var logoImage: UIImage?
    var canShowTypingIndicator: Bool?
    var typingLabelText: String?

    /**
     - returns:
     `WMChatNavigationBarConfig` object.
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMChatNavigationBarConfig {
        let navigationConfig = WMChatNavigationBarConfig(navigationConfig: navigationBarConfig)
        navigationConfig.logoImage = logoImage
        navigationConfig.canShowTypingIndicator = canShowTypingIndicator
        navigationConfig.typingLabelText = typingLabelText
        return navigationConfig
    }

    /**
     Sets logo image.
     - parameter logoImage:
     Logo image.
     - returns:
     `WMChatNavigationBarConfigBuilder` object with logo image set.
     - copyright:
     2023 Roxchat
     */
    public func set(logoImage: UIImage) -> Self {
        self.logoImage = logoImage
        return self
    }

    /**
     Sets can show typing indicator.
     - parameter canShowTypingIndicator:
     Can show typing indicator.
     - returns:
     `WMChatNavigationBarConfigBuilder` object with can show typing indicator set.
     - copyright:
     2023 Roxchat
     */
    public func set(canShowTypingIndicator: Bool) -> Self {
        self.canShowTypingIndicator = canShowTypingIndicator
        return self
    }

    /**
     Sets typing label text.
     - parameter typingLabelText:
     Typing label text.
     - returns:
     `WMChatNavigationBarConfigBuilder` object with typing label text set.
     - copyright:
     2023 Roxchat
     */
    public func set(typingLabelText: String) -> Self {
        self.typingLabelText = typingLabelText
        return self
    }
}
