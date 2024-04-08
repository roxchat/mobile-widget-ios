//
//  WMChatViewControllerConfigBuilder.swift
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
 Chat view controller config.
 - copyright:
 2023 Roxchat
 */
public class WMChatViewControllerConfigBuilder: WMViewControllerConfigBuilder {
    var showScrollButtonView: Bool?
    var scrollButtonImage: UIImage?
    var showScrollButtonCounter: Bool?
    var openFromNotification: Bool?
    var requestMessagesCount: Int?
    var refreshControlAttributedTitle: NSAttributedString?
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

    /**
     - returns:
     `WMViewControllerConfig` object with config.
     - copyright:
     2023 Roxchat
     */
    public override func build() -> WMViewControllerConfig {
        let chatConfig = WMChatViewControllerConfig(viewControllerConfig: viewControllerConfig)
        chatConfig.showScrollButtonView = showScrollButtonView
        chatConfig.scrollButtonImage = scrollButtonImage
        chatConfig.showScrollButtonCounter = showScrollButtonCounter
        chatConfig.openFromNotification = openFromNotification
        chatConfig.requestMessagesCount = requestMessagesCount
        chatConfig.refreshControlAttributedTitle = refreshControlAttributedTitle
        chatConfig.visitorCellsConfig = visitorCellsConfig
        chatConfig.operatorCellsConfig = operatorCellsConfig
        chatConfig.botButtonsConfig = botButtonsConfig
        chatConfig.toolbarConfig = toolbarConfig
        chatConfig.networkErrorViewConfig = networkErrorViewConfig
        chatConfig.popupActionControllerConfig = popupActionControllerConfig
        chatConfig.quoteViewConfig = quoteViewConfig
        chatConfig.editBarConfig = editBarConfig
        chatConfig.surveyViewConfig = surveyViewConfig
        chatConfig.infoCellConfig = infoCellConfig
        chatConfig.emptyChatTitle = emptyChatTitle
        return chatConfig
    }
    
    // MARK: Helpers
    /**
     Sets open from notification.
     - parameter openFromNotification:
     If **true** scroll to first unread message on first appear.
     Default value - **false**
     - returns:
     `WMChatViewControllerConfigBuilder` object with show scroll button view set.
     - copyright:
     2023 Roxchat
     */
    public func set(openFromNotification: Bool) -> Self {
        self.openFromNotification = openFromNotification
        return self
    }

    // MARK: ScrollButtonView
    /**
     Sets needs show scroll button view.
     - parameter showScrollButtonView:
     Show scroll button view.
     - returns:
     `WMChatViewControllerConfigBuilder` object with show scroll button view set.
     - copyright:
     2023 Roxchat
     */
    public func set(showScrollButtonView: Bool) -> Self {
        self.showScrollButtonView = showScrollButtonView
        return self
    }

    /**
     Sets scroll button image.
     - parameter scrollButtonImage:
     Image.
     - returns:
     `WMChatViewControllerConfigBuilder` object with scroll button image set.
     - copyright:
     2023 Roxchat
     */
    public func set(scrollButtonImage: UIImage) -> Self {
        self.scrollButtonImage = scrollButtonImage
        return self
    }

    /**
     Sets needs show scroll button counter.
     - parameter showScrollButtonCounter:
     Show scroll button counter.
     - returns:
     `WMChatViewControllerConfigBuilder` object with show scroll button counter set.
     - copyright:
     2023 Roxchat
     */
    public func set(showScrollButtonCounter: Bool) -> Self {
        self.showScrollButtonCounter = showScrollButtonCounter
        return self
    }

    // MARK: RefreshControl
    /**
     Sets request messages count.
     - parameter navigationBarConfig:
     Count.
     - returns:
     `WMChatViewControllerConfigBuilder` object with request messages count set.
     - copyright:
     2023 Roxchat
     */
    public func set(requestMessagesCount: Int) -> Self {
        self.requestMessagesCount = requestMessagesCount
        return self
    }

    /**
     Sets refresh control attributed title.
     - parameter refreshControlAttributedTitle:
     Title.
     - returns:
     `WMChatViewControllerConfigBuilder` object with refresh control attributed title set.
     - copyright:
     2023 Roxchat
     */
    public func set(refreshControlAttributedTitle: NSAttributedString) -> Self {
        self.refreshControlAttributedTitle = refreshControlAttributedTitle
        return self
    }

    // MARK: Cells
    /**
     Sets visitor cell config.
     - parameter visitorCellsConfig:
     Visitor cell config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with visitor cell config set.
     - copyright:
     2023 Roxchat
     */
    public func set(visitorCellsConfig: WMCellsConfig) -> Self {
        self.visitorCellsConfig = visitorCellsConfig
        return self
    }

    /**
     Sets operator cell config.
     - parameter operatorCellsConfig:
     Operator cell config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with operator cell config set.
     - copyright:
     2023 Roxchat
     */
    public func set(operatorCellsConfig: WMCellsConfig) -> Self {
        self.operatorCellsConfig = operatorCellsConfig
        return self
    }

    /**
     Sets bot buttons config.
     - parameter botButtonsConfig:
     Bot buttons config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with bot buttons config set.
     - copyright:
     2023 Roxchat
     */
    public func set(botButtonsConfig: WMAbstractCellConfig) -> Self {
        self.botButtonsConfig = botButtonsConfig
        return self
    }
    
    /**
     Sets info cells config.
     - parameter infoCellConfig:
     Bot buttons config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with  info cells config set.
     - copyright:
     2024 Roxchat
     */
    public func set(infoCellConfig: WMAbstractCellConfig) -> Self {
        self.infoCellConfig = infoCellConfig
        return self
    }


    // MARK: Toolbar
    /**
     Sets toolbar config.
     - parameter toolbarConfig:
     Toolbar config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with toolbar config set.
     - copyright:
     2023 Roxchat
     */
    public func set(toolbarConfig: WMToolbarConfig) -> Self {
        self.toolbarConfig = toolbarConfig
        return self
    }

    // MARK: NavigationBar
    /**
     Sets network error view config.
     - parameter networkErrorViewConfig:
     Network error view config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with network error view config set.
     - copyright:
     2023 Roxchat
     */
    public func set(networkErrorViewConfig: WMNetworkErrorViewConfig) -> Self {
        self.networkErrorViewConfig = networkErrorViewConfig
        return self
    }

    // MARK: ContextMenu
    /**
     Sets popup action controller config.
     - parameter popupActionControllerConfig:
     Popup action controller config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with popup action controller config set.
     - copyright:
     2023 Roxchat
     */
    public func set(popupActionControllerConfig: WMPopupActionControllerConfig) -> Self {
        self.popupActionControllerConfig = popupActionControllerConfig
        return self
    }

    // MARK: QuoteView
    /**
     Sets quote view config.
     - parameter quoteViewConfig:
     Quote view config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with quote view config set.
     - copyright:
     2023 Roxchat
     */
    public func set(quoteViewConfig: WMHelperInputViewConfig) -> Self {
        self.quoteViewConfig = quoteViewConfig
        return self
    }

    /**
     Sets edit bar config.
     - parameter editBarConfig:
     Edit bar config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with edit bar config set.
     - copyright:
     2023 Roxchat
     */
    public func set(editBarConfig: WMHelperInputViewConfig) -> Self {
        self.editBarConfig = editBarConfig
        return self
    }

    // MARK: SurveyView
    /**
     Sets survey view config.
     - parameter surveyViewConfig:
     Survey view config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with survey view config set.
     - copyright:
     2023 Roxchat
     */
    public func set(surveyViewConfig: WMSurveyViewConfig) -> Self {
        self.surveyViewConfig = surveyViewConfig
        return self
    }
    
    /**
     Sets empty chat title.
     - parameter emptyChatTitle:
     Survey view config.
     - returns:
     `WMChatViewControllerConfigBuilder` object with empty chat title set.
     - copyright:
     2024 Rox.Chat
     */
    public func set(emptyChatTitle: String) -> Self {
        self.emptyChatTitle = emptyChatTitle
        return self
    }
}
