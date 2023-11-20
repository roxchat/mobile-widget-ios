//
//  WMSurveyViewConfigBuilder.swift
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
import Cosmos
import UIKit

/**
 Survey View config.
 - copyright:
 2023 Roxchat
 */
public class WMSurveyViewConfigBuilder {
    var rateConfig = WMSurveyViewConfig()

    public init() { }

    /**
     - returns:
     `WMSurveyViewConfig` object.
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMSurveyViewConfig {
        return rateConfig
    }

    /**
     Sets survey view title.
     - parameter title:
     Title.
     - returns:
     `WMSurveyViewConfigBuilder` object with survey view title set.
     - copyright:
     2023 Roxchat
     */
    public func set(title: NSAttributedString) -> Self {
        rateConfig.title = title
        return self
    }

    /**
     Sets survey view subtitle.
     - parameter subtitle:
     Subtitle.
     - returns:
     `WMSurveyViewConfigBuilder` object with survey view subtitle set.
     - copyright:
     2023 Roxchat
     */
    public func set(subtitle: NSAttributedString) -> Self {
        rateConfig.subtitle = subtitle
        return self
    }

    /**
     Sets survey view cosmos settings.
     - parameter cosmosSettings:
     Survey view cosmos settings.
     - returns:
     `WMSurveyViewConfigBuilder` object with survey view cosmos settings set.
     - seealso:
     `CosmosSettings`
     - copyright:
     2023 Roxchat
     */
    public func set(cosmosSettings: CosmosSettings) -> Self {
        rateConfig.cosmosSettings = cosmosSettings
        return self
    }

    /**
     Sets stars view size.
     - parameter starsViewSize:
     Stars view size.
     - returns:
     `WMSurveyViewConfigBuilder` object with stars view size set.
     - copyright:
     2023 Roxchat
     */
    public func set(starsViewSize: CGSize) -> Self {
        rateConfig.starsViewSize = starsViewSize
        return self
    }

    /**
     Sets survey view button title.
     - parameter buttonTitle:
     Title.
     - returns:
     `WMSurveyViewConfigBuilder` object with survey view button title set.
     - copyright:
     2023 Roxchat
     */
    public func set(buttonTitle: NSAttributedString) -> Self {
        rateConfig.buttonTitle = buttonTitle
        return self
    }

    /**
     Sets survey view button сolor.
     - parameter buttonColor:
     Button сolor.
     - returns:
     `WMSurveyViewConfigBuilder` object with survey view button сolor set.
     - copyright:
     2023 Roxchat
     */
    public func set(buttonColor: UIColor) -> Self {
        rateConfig.buttonColor = buttonColor
        return self
    }

    /**
     Sets survey view button corner radius.
     - parameter buttonCornerRadius:
     Survey view button corner radius.
     - returns:
     `WMSurveyViewConfigBuilder` object with survey view button corner radius set.
     - copyright:
     2023 Roxchat
     */
    public func set(buttonCornerRadius: CGFloat) -> Self {
        rateConfig.buttonCornerRadius = buttonCornerRadius
        return self
    }
}
