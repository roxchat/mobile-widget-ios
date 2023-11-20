//
//  WMFileViewControllerConfigBuilder.swift
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

/**
 File view controller config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMFileViewControllerConfigBuilder: WMViewControllerConfigBuilder {
    var loadingLabelText: NSAttributedString?
    var canShowLoadingIndicator: Bool?

    /**
     - returns:
     `WMViewControllerConfig` object.
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMViewControllerConfig {
        let fileControllerConfig = WMFileViewControllerConfig(viewControllerConfig: viewControllerConfig)
        fileControllerConfig.loadingLabelText = loadingLabelText
        fileControllerConfig.canShowLoadingIndicator = canShowLoadingIndicator
        return fileControllerConfig
    }

    /**
     Sets loading file label text.
     - parameter loadingLabelText:
     Loading file label text.
     - returns:
     `WMFileViewControllerConfigBuilder` object with loading file label text set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(loadingLabelText: NSAttributedString) -> Self {
        self.loadingLabelText = loadingLabelText
        return self
    }

    /**
     Sets can show loading file idicator.
     - parameter canShowLoadingIndicator:
     Can show loading file idicator.
     - returns:
     `WMFileViewControllerConfigBuilder` object with can show loading file idicator set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(canShowLoadingIndicator: Bool) -> Self {
        self.canShowLoadingIndicator = canShowLoadingIndicator
        return self
    }
}
