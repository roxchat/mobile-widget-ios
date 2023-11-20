//
//  WMCellConfigBuilder.swift
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
 Cells config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMCellsConfigBuilder {
    let cellsConfig = WMCellsConfig()
    
    public init() { }
    
    /**
     Builds new `WMCellsConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMCellsConfig {
        return cellsConfig
    }
    
    /**
     Sets text cell config.
     - parameter textCellConfig:
     Text cell config.
     - returns:
     `WMCellConfigBuilder` object with text cell config set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(textCellConfig: WMAbstractCellConfig) -> Self {
        cellsConfig.textCellConfig = textCellConfig
        return self
    }
    
    /**
     Sets image cell config.
     - parameter imageCellConfig:
     Image cell config.
     - returns:
     `WMCellConfigBuilder` object with image cell config set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(imageCellConfig: WMAbstractCellConfig) -> Self {
        cellsConfig.imageCellConfig = imageCellConfig
        return self
    }
    
    /**
     Sets file cell config.
     - parameter fileCellConfig:
     File cell config.
     - returns:
     `WMCellConfigBuilder` object with file cell config set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(fileCellConfig: WMAbstractCellConfig) -> Self {
        cellsConfig.fileCellConfig = fileCellConfig
        return self
    }
}

/**
 Abstract cell config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMAbstractCellConfigBuilder {
    var cellConfig = WMAbstractCellConfig()

    public init() { }

    /**
     Builds new `WMAbstractCellConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func build() -> WMAbstractCellConfig {
        return cellConfig
    }

    /**
     Sets cell background color.
     - parameter backgroundColor:
     Cell background color.
     - returns:
     `WMAbstractCellConfigBuilder` object with background color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(backgroundColor: UIColor) -> Self {
        cellConfig.backgroundColor = backgroundColor
        return self
    }

    /**
     Sets cell round corners.
     - parameter roundCorners:
     Corner round corners.
     - returns:
     `WMAbstractCellConfigBuilder` object with round corners set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(roundCorners: CACornerMask) -> Self {
        cellConfig.roundCorners = roundCorners
        return self
    }

    /**
     Sets cell corner radius.
     - parameter cornerRadius:
     Corner radius.
     - returns:
     `WMAbstractCellConfigBuilder` object with corner radius set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(cornerRadius: CGFloat) -> Self {
        cellConfig.cornerRadius = cornerRadius
        return self
    }

    /**
     Sets subtitle attributes.
     - parameter subtitleAttributes:
     Attributes for subtitle label.
     - returns:
     `WMAbstractCellConfigBuilder` object with text color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(subtitleAttributes: [NSAttributedString.Key : Any]?) -> Self {
        cellConfig.subtitleAttributes = subtitleAttributes
        return self
    }
    
    /**
     Sets title attributes.
     - parameter titleAttributes:
     Attributes for title label.
     - returns:
     `WMAbstractCellConfigBuilder` object with text color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(titleAttributes: [NSAttributedString.Key : Any]?) -> Self {
        cellConfig.titleAttributes = titleAttributes
        return self
    }

    /**
     Sets cell stroke width.
     - parameter strokeWidth:
     Stroke width.
     - returns:
     `WMAbstractCellConfigBuilder` object with stroke width set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(strokeWidth: CGFloat) -> Self {
        cellConfig.strokeWidth = strokeWidth
        return self
    }

    /**
     Sets cell stroke color.
     - parameter strokeColor:
     Stroke color.
     - returns:
     `WMAbstractCellConfigBuilder` object with stroke color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(strokeColor: UIColor) -> Self {
        cellConfig.strokeColor = strokeColor
        return self
    }

}


/**
 Popup menu cell config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMPopupActionCellConfigBuilder: WMAbstractCellConfigBuilder {
    
    var actionText: String?
    var actionImage: UIImage?
    
    /**
     Builds new `WMPopupActionCellConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMPopupActionCellConfig {
        let config = WMPopupActionCellConfig(cellConfig: cellConfig)
        config.actionText = actionText
        config.actionImage = actionImage
        return config
    }

    /**
     Sets popup menu button action image.
     - parameter actionImage:
     Popup menu action image.
     - returns:
     `WMPopupActionCellConfigBuilder` object with button action image set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(actionImage: UIImage?) -> Self {
        self.actionImage = actionImage
        return self
    }

    /**
     Sets popup menu button stroke color.
     - parameter actionText:
     Popup menu action text.
     - returns:
     `WMPopupActionCellConfigBuilder` object with button stroke color set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(actionText: String?) -> Self {
        self.actionText = actionText
        return self
    }
}

/**
 Text cell config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMTextCellConfigBuilder: WMAbstractCellConfigBuilder {
    
    /**
     Builds new `WMTextCellConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMTextCellConfig {
        return WMTextCellConfig(cellConfig: cellConfig)
    }
}

/**
 Image cell config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMImageCellConfigBuilder: WMAbstractCellConfigBuilder {
    
    /**
     Builds new `WMImageCellConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMImageCellConfig {
        return WMImageCellConfig(cellConfig: cellConfig)
    }
}

/**
 File cell config.
 - author:
 Aslan Kutumbaev
 - copyright:
 2023 Roxchat
 */
public class WMFileCellConfigBuilder: WMAbstractCellConfigBuilder {
    var downloadFileImage: UIImage?
    var readyFileImage: UIImage?
    var uploadFileImage: UIImage?
    var errorFileImage: UIImage?
    
    var downloadFileImageColor: UIColor?
    var readyFileImageColor: UIColor?
    var uploadFileImageColor: UIColor?
    var errorFileImageColor: UIColor?
    
    /**
     Builds new `WMFileCellConfig` object.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMFileCellConfig {
        let cellConfig = WMFileCellConfig(cellConfig: cellConfig)
        
        cellConfig.downloadFileImage = downloadFileImage
        cellConfig.readyFileImage = readyFileImage
        cellConfig.uploadFileImage = uploadFileImage
        cellConfig.errorFileImage = errorFileImage
        cellConfig.readyToDownloadFileImageColor = downloadFileImageColor
        cellConfig.successDownloadedFileImageColor = readyFileImageColor
        cellConfig.uploadFileImageColor = uploadFileImageColor
        cellConfig.errorFileImageColor = errorFileImageColor
        
        return cellConfig
    }
    
    /**
     Sets file image for state.
     - parameter fileImage:
     Image.
     - parameter state:
     FileState.
     - returns:
     `WMFileCellConfigBuilder` object with file image for state set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(fileImage: UIImage, for state: WMFileCellConfig.FileState) -> Self {
        switch state {
        case .download:
            downloadFileImage = fileImage
        case .ready:
            readyFileImage = fileImage
        case .upload:
            uploadFileImage = fileImage
        case .error:
            errorFileImage = fileImage
        }
        return self
    }
    
    /**
     Sets file image color for state.
     - parameter fileImageColor:
     Image.
     - parameter state:
     FileState.
     - returns:
     `WMFileCellConfigBuilder` object with file image color for state set.
     - author:
     Aslan Kutumbaev
     - copyright:
     2023 Roxchat
     */
    public func set(fileImageColor: UIColor, for state: WMFileCellConfig.FileState) -> Self {
        switch state {
        case .download:
            downloadFileImageColor = fileImageColor
        case .ready:
            readyFileImageColor = fileImageColor
        case .upload:
            uploadFileImageColor = fileImageColor
        case .error:
            errorFileImageColor = fileImageColor
        }
        return self
    }
}
