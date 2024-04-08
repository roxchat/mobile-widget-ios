//
//  WMCellConfig.swift
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
import Cosmos

// MARK: ViewControllerConfigs
public class WMViewControllerConfig {
    var backgroundColor: UIColor?
    var navigationBarConfig: WMNavigationBarConfig?

    init() { }

    init(viewControllerConfig: WMViewControllerConfig) {
        backgroundColor = viewControllerConfig.backgroundColor
        navigationBarConfig = viewControllerConfig.navigationBarConfig
    }
}

public class WMChatViewControllerConfig: WMViewControllerConfig {
    var showScrollButtonView: Bool?
    var scrollButtonImage: UIImage?
    var showScrollButtonCounter: Bool?
    var openFromNotification: Bool?
    var requestMessagesCount: Int?
    var refreshControlAttributedTitle: NSAttributedString?
    var visitorMessageBackgroundColor: UIColor?
    var visitorCellsConfig: WMCellsConfig?
    var operatorCellsConfig: WMCellsConfig?
    var botButtonsConfig: WMAbstractCellConfig?
    var toolbarConfig: WMToolbarConfig?
    var networkErrorViewConfig: WMNetworkErrorViewConfig?
    var popupActionControllerConfig: WMPopupActionControllerConfig?
    var quoteViewConfig: WMHelperInputViewConfig?
    var editBarConfig: WMHelperInputViewConfig?
    var surveyViewConfig: WMSurveyViewConfig?
    var infoCellConfig: WMAbstractCellConfig?
    var emptyChatTitle: String?
}

public class WMImageViewControllerConfig: WMViewControllerConfig {
    var saveViewColor: UIColor?
}

public class WMFileViewControllerConfig: WMViewControllerConfig {
    var loadingLabelText: NSAttributedString?
    var canShowLoadingIndicator: Bool?
}

// MARK: CellConfigs
public class WMCellsConfig {
    var textCellConfig: WMAbstractCellConfig?
    var imageCellConfig: WMAbstractCellConfig?
    var fileCellConfig: WMAbstractCellConfig?
}

public class WMAbstractCellConfig {
    var backgroundColor: UIColor?
    var roundCorners: CACornerMask?
    var cornerRadius: CGFloat?
    var titleAttributes: [NSAttributedString.Key : Any]?
    var subtitleAttributes: [NSAttributedString.Key : Any]?
    var strokeWidth: CGFloat?
    var strokeColor: UIColor?
    
    init() { }
    
    init(cellConfig: WMAbstractCellConfig) {
        backgroundColor = cellConfig.backgroundColor
        roundCorners = cellConfig.roundCorners
        cornerRadius = cellConfig.cornerRadius
        titleAttributes = cellConfig.titleAttributes
        subtitleAttributes = cellConfig.subtitleAttributes
        strokeWidth = cellConfig.strokeWidth
        strokeColor = cellConfig.strokeColor
    }
}

public class WMTextCellConfig: WMAbstractCellConfig { }

public class WMImageCellConfig: WMAbstractCellConfig { }

public class WMFileCellConfig: WMAbstractCellConfig {
    var downloadFileImage: UIImage?
    var readyFileImage: UIImage?
    var uploadFileImage: UIImage?
    var errorFileImage: UIImage?
    
    var readyToDownloadFileImageColor: UIColor?
    var successDownloadedFileImageColor: UIColor?
    var uploadFileImageColor: UIColor?
    var errorFileImageColor: UIColor?
    
    public enum FileState {
        case download
        case ready
        case upload
        case error
    }
}

public class WMPopupActionControllerConfig {
    var viewModels = [PopupAction : WMPopupActionCellConfig]()
    var cornerRadius: CGFloat?
    var strokeWidth: CGFloat?
    var strokeColor: UIColor?
    var cellsHeight: CGFloat?
}

public class WMPopupActionCellConfig: WMAbstractCellConfig {
    var actionImage: UIImage?
    var actionText: String?
}

// MARK: ToolbarConfigs
public class WMToolbarConfig {
    var sendButtonImage: UIImage?
    var inactiveSendButtonImage: UIImage?
    var addAttachmentImage: UIImage?
    var placeholderText: String?
    var textViewFont: UIFont?
    var textViewStrokeWidth: CGFloat?
    var emptyTextViewStrokeColor: UIColor?
    var filledTextViewStrokeColor: UIColor?
    var textViewCornerRadius: CGFloat?
    var textViewMaxHeight: CGFloat?
    var toolbarBackgroundColor: UIColor?
    var inputViewColor: UIColor?
}

// MARK: WMNetworkErrorViewConfig
public class WMNetworkErrorViewConfig {
    var image: UIImage?
    var text: String?
    var backgroundColor: UIColor?
    var textColor: UIColor?
}

// MARK: WMHelperInputViewConfig
public class WMHelperInputViewConfig {
    var backgroundColor: UIColor?
    var quoteViewBackgroundColor: UIColor?
    var quoteTextColor: UIColor?
    var authorTextColor: UIColor?
    var quoteTextFont: UIFont?
    var authorTextFont: UIFont?
    var quoteLineColor: UIColor?
    var height: CGFloat?
}

// MARK: WMSurveyViewConfig
public class WMSurveyViewConfig {
    var title: NSAttributedString?
    var subtitle: NSAttributedString?
    var cosmosSettings: CosmosSettings?
    var starsViewSize: CGSize?
    var buttonTitle: NSAttributedString?
    var buttonColor: UIColor?
    var buttonCornerRadius: CGFloat?
    var changeRateEnabled: Bool?
}

// MARK: NavigationBarConfigs
public class WMNavigationBarConfig {
    var rightBarButtonImage: UIImage?
    var textColorOfflineState: UIColor?
    var textColorOnlineState: UIColor?
    var backgroundColorOnlineState: UIColor?
    var backgroundColorOfflineState: UIColor?

    init() { }

    init(navigationConfig: WMNavigationBarConfig) {
        rightBarButtonImage = navigationConfig.rightBarButtonImage
        textColorOfflineState = navigationConfig.textColorOfflineState
        textColorOnlineState = navigationConfig.textColorOnlineState
        backgroundColorOnlineState = navigationConfig.backgroundColorOnlineState
        backgroundColorOfflineState = navigationConfig.backgroundColorOfflineState
    }
}

public class WMChatNavigationBarConfig: WMNavigationBarConfig {
    var logoImage: UIImage?
    var canShowTypingIndicator: Bool?
    var typingLabelText: String?
}

public class WMImageNavigationBarConfig: WMNavigationBarConfig { }

public class WMFileNavigationBarConfig: WMNavigationBarConfig { }
