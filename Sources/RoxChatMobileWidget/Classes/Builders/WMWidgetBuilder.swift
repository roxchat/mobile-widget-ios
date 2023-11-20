//
//  WMWidgetBuilder.swift
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
import RoxchatClientLibrary

/**
 Widget config.
 - copyright:
 2023 Roxchat
 */
public class WMWidgetBuilder {
    let chatViewController: ChatViewController

    // Required for builder pattern
    public init() {
        chatViewController = ChatViewController.loadViewControllerFromXib()
    }

    /**
     - returns:
     `UIViewController` object.
     - copyright:
     2023 Roxchat
     */
    public func build() -> UIViewController {
        return chatViewController
    }

    // MARK: Session
    /**
     Sets session config.
     - parameter sessionBuilder:
     This parameter response for session configuration. For create and set this configuration you must use Roxchat.newSessionBuilder().
     - seealso:
     `SessionBuilder`
     - returns:
     `WMWidgetBuilder` object with session config set.
     - copyright:
     2023 Roxchat
     */
    public func set(sessionBuilder: SessionBuilder?) -> Self {
        RoxchatServiceController.shared.sessionBuilder = sessionBuilder
        return self
    }

    /**
     Sets chat view controller config.
     - parameter chatViewControllerConfig:
     Chat view controller config.
     - returns:
     `WMWidgetBuilder` object with chat view controller config set.
     - copyright:
     2023 Roxchat
     */
    public func set(chatViewControllerConfig: WMViewControllerConfig) -> Self {
        chatViewController.chatConfig = chatViewControllerConfig
        return self
    }

    /**
     Sets image view controller config.
     - parameter imageViewControllerConfig:
     Image view controller config.
     - returns:
     `WMWidgetBuilder` object with image view controller config set.
     - copyright:
     2023 Roxchat
     */
    public func set(imageViewControllerConfig: WMViewControllerConfig) -> Self {
        chatViewController.imageViewControllerConfig = imageViewControllerConfig
        return self
    }

    /**
     Sets file view controller config.
     - parameter fileViewControllerConfig:
     File view controller config.
     - returns:
     `WMWidgetBuilder` object with file view controller config set.
     - copyright:
     2023 Roxchat
     */
    public func set(fileViewControllerConfig: WMViewControllerConfig) -> Self {
        chatViewController.fileViewControllerConfig = fileViewControllerConfig
        return self
    }
    
    /**
     Sets agreement url.
     - parameter processingPersonalDataUrl:
     Processing personal data url.
     - returns:
     `WMWidgetBuilder` object with processing personal data url set.
     - copyright:
     2025 Roxchat
     */
    public func set(processingPersonalDataUrl: String?) -> Self {
        chatViewController.processingPersonalDataUrl = processingPersonalDataUrl
        return self
    }

}
