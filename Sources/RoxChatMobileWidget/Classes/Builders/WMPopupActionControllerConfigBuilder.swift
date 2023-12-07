//
//  WMPopupActionControllerConfigBuilder.swift
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
 Popup menu config.
 - copyright:
 2023 Roxchat
 */
public class WMPopupActionControllerConfigBuilder {
    let actionControllerConfig = WMPopupActionControllerConfig()

    public init() { }

    /**
     - returns:
     `WMPopupActionControllerConfig` object.
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMPopupActionControllerConfig {
        return actionControllerConfig
    }

    /**
     Sets popup menu view corner radius.
     - parameter cornerRadius:
     Corner radius.
     - returns:
     `WMPopupActionControllerConfigBuilder` object with corner radius set.
     - copyright:
     2023 Roxchat
     */
    public func set(cornerRadius: CGFloat?) -> Self {
        actionControllerConfig.cornerRadius = cornerRadius
        return self
    }

    /**
     Sets popup menu view stroke width.
     - parameter strokeWidth:
     Stroke width.
     - returns:
     `WMPopupActionControllerConfigBuilder` object with stroke width set.
     - copyright:
     2023 Roxchat
     */
    public func set(strokeWidth: CGFloat?) -> Self {
        actionControllerConfig.strokeWidth = strokeWidth
        return self
    }

    /**
     Sets popup menu view stroke color.
     - parameter strokeColor:
     Stroke color.
     - returns:
     `WMPopupActionControllerConfigBuilder` object with stroke color set.
     - copyright:
     2023 Roxchat
     */
    public func set(strokeColor: UIColor?) -> Self {
        actionControllerConfig.strokeColor = strokeColor
        return self
    }

    /**
     Sets popup menu view cells height.
     - parameter cellsHeight:
     Cells height.
     - returns:
     `WMPopupActionControllerConfigBuilder` object with cells height set.
     - copyright:
     2023 Roxchat
     */
    public func set(cellsHeight: CGFloat?) -> Self {
        actionControllerConfig.cellsHeight = cellsHeight
        return self
    }

    /**
     Sets config for popup view action.
     - parameter cellConfig:
     Cell config.
     - parameter action:
     Popup action to set config.
     - returns:
     `WMPopupActionControllerConfigBuilder` object with cell config for action set.
     - copyright:
     2023 Roxchat
     */
    public func set(cellConfig: WMPopupActionCellConfig, for action: PopupAction) -> Self {
        actionControllerConfig.viewModels[action] = cellConfig
        return self
    }
}
