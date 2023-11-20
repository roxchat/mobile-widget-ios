//
//  WMToolbarConfigBuilder.swift
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
 Toolbar View config.
 - copyright:
 2023 Roxchat
 */
public class WMToolbarConfigBuilder {
    let toolbar = WMToolbarConfig()

    public init() { }

    /**
     - returns:
     `WMToolbarConfig` object.
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMToolbarConfig {
        return toolbar
    }

    /**
     Sets send button image.
     - parameter sendButtonImage:
     Send button image.
     - returns:
     `WMToolbarConfigBuilder` object with send button image set.
     - copyright:
     2023 Roxchat
     */
    public func set(sendButtonImage: UIImage) -> WMToolbarConfigBuilder {
        toolbar.sendButtonImage = sendButtonImage
        return self
    }

    /**
     Sets attachment image.
     - parameter addAttachmentImage:
     Image.
     - returns:
     `WMToolbarConfigBuilder` object with attachment image set.
     - copyright:
     2023 Roxchat
     */
    public func set(addAttachmentImage: UIImage) -> WMToolbarConfigBuilder {
        toolbar.addAttachmentImage = addAttachmentImage
        return self
    }

    /**
     Sets Toolbar View placeholder text.
     - parameter placeholderText:
     Placeholder text.
     - returns:
     `WMToolbarConfigBuilder` object with placeholder text set.
     - copyright:
     2023 Roxchat
     */
    public func set(placeholderText: String) -> WMToolbarConfigBuilder {
        toolbar.placeholderText = placeholderText
        return self
    }

    /**
     Sets text view font.
     - parameter textViewFont:
     Text view font.
     - returns:
     `WMToolbarConfigBuilder` object with text view font set.
     - copyright:
     2023 Roxchat
     */
    public func set(textViewFont: UIFont) -> WMToolbarConfigBuilder {
        toolbar.textViewFont = textViewFont
        return self
    }

    /**
     Sets text view stroke width.
     - parameter textViewStrokeWidth:
     Text view stroke width.
     - returns:
     `WMToolbarConfigBuilder` object with text view stroke width set.
     - copyright:
     2023 Roxchat
     */
    public func set(textViewStrokeWidth: CGFloat) -> WMToolbarConfigBuilder {
        toolbar.textViewStrokeWidth = textViewStrokeWidth
        return self
    }

    /**
     Sets empty text view stroke color.
     - parameter emptyTextViewStrokeColor:
     Color.
     - returns:
     `WMToolbarConfigBuilder` object with empty text view stroke color set.
     - copyright:
     2023 Roxchat
     */
    public func set(emptyTextViewStrokeColor: UIColor) -> WMToolbarConfigBuilder {
        toolbar.emptyTextViewStrokeColor = emptyTextViewStrokeColor
        return self
    }

    /**
     Sets filled text vew stroke color.
     - parameter filledTextViewStrokeColor:
     Color.
     - returns:
     `WMToolbarConfigBuilder` object with filled text vew stroke color set.
     - copyright:
     2023 Roxchat
     */
    public func set(filledTextViewStrokeColor: UIColor) -> WMToolbarConfigBuilder {
        toolbar.filledTextViewStrokeColor = filledTextViewStrokeColor
        return self
    }

    /**
     Sets text view corner radius.
     - parameter textViewCornerRadius:
     Corner radius.
     - returns:
     `WMToolbarConfigBuilder` object with text view corner radius set.
     - copyright:
     2023 Roxchat
     */
    public func set(textViewCornerRadius: CGFloat) -> WMToolbarConfigBuilder {
        toolbar.textViewCornerRadius = textViewCornerRadius
        return self
    }

    /**
     Sets text view max height.
     - parameter textViewMaxHeight:
     Text view max height.
     - returns:
     `WMToolbarConfigBuilder` object with text view max height set.
     - copyright:
     2023 Roxchat
     */
    public func set(textViewMaxHeight: CGFloat) -> WMToolbarConfigBuilder {
        toolbar.textViewMaxHeight = textViewMaxHeight
        return self
    }
}
