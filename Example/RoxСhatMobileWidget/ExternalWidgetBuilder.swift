//
//  ExternalWidgetBuilder.swift
//  RoxChat_Example
//
//  Copyright © 2023 Roxchat. All rights reserved.
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

import Cosmos
import RoxchatClientLibrary
import Foundation
import RoxchatMobileWidget
import UIKit

final class ExternalWidgetBuilder {
    
    func buildDefaultWidget(accountName: String,
                            location: String,
                            localHistoryStoragingEnabled: Bool = true,
                            multivisitorSection: String = "",
                            pageTitle: String? = nil,
                            providedAuthorizationToken: String? = nil,
                            providedAuthorizationTokenStateListener: ProvidedAuthorizationTokenStateListener? = nil,
                            remoteNotificationSystem: Roxchat.RemoteNotificationSystem = .apns,
                            visitorDataClearingEnabled: Bool = false,
                            visitorFields: String? = nil,
                            roxchatLogger: RoxchatLogger? = nil,
                            roxchatLoggerVerbosityLevel: SessionBuilder.RoxchatLoggerVerbosityLevel? = nil,
                            availableLogTypes: [SessionBuilder.RoxchatLogType] = [SessionBuilder.RoxchatLogType](),
                            roxchatAlert: RoxchatAlert? = nil,
                            prechat: String? = nil,
                            onlineStatusRequestFrequencyInMillis: Int64? = nil) -> UIViewController {
        let sessionBuilder = buildSessionConfig(accountName: accountName,
                                                location: location,
                                                localHistoryStoragingEnabled: localHistoryStoragingEnabled,
                                                multivisitorSection: multivisitorSection,
                                                pageTitle: pageTitle,
                                                providedAuthorizationToken: providedAuthorizationToken,
                                                providedAuthorizationTokenStateListener: providedAuthorizationTokenStateListener,
                                                remoteNotificationSystem: remoteNotificationSystem,
                                                visitorDataClearingEnabled: visitorDataClearingEnabled,
                                                visitorFields: visitorFields,
                                                roxchatLogger: roxchatLogger,
                                                roxchatLoggerVerbosityLevel: roxchatLoggerVerbosityLevel,
                                                availableLogTypes: availableLogTypes,
                                                roxchatAlert: roxchatAlert,
                                                prechat: prechat,
                                                onlineStatusRequestFrequencyInMillis: onlineStatusRequestFrequencyInMillis)
        let chatControllerConfig = chatViewControllerConfig()
        let imageControllerConfig = imageViewControllerConfig()
        let fileControllerConfig = fileViewControllerConfig()

        let widget = WMWidgetBuilder()
            .set(sessionBuilder: sessionBuilder)
            .set(chatViewControllerConfig: chatControllerConfig)
            .set(imageViewControllerConfig: imageControllerConfig)
            .set(fileViewControllerConfig: fileControllerConfig)
            .build()
        return widget
    }
    
    private func buildSessionConfig(accountName: String,
                                    location: String,
                                    localHistoryStoragingEnabled: Bool = true,
                                    multivisitorSection: String? = nil,
                                    pageTitle: String? = nil,
                                    providedAuthorizationToken: String? = nil,
                                    providedAuthorizationTokenStateListener: ProvidedAuthorizationTokenStateListener? = nil,
                                    remoteNotificationSystem: Roxchat.RemoteNotificationSystem = .none,
                                    visitorDataClearingEnabled: Bool? = nil,
                                    visitorFields: String? = nil,
                                    roxchatLogger: RoxchatLogger? = nil,
                                    roxchatLoggerVerbosityLevel: SessionBuilder.RoxchatLoggerVerbosityLevel? = nil,
                                    availableLogTypes: [SessionBuilder.RoxchatLogType] = [SessionBuilder.RoxchatLogType](),
                                    roxchatAlert: RoxchatAlert? = nil,
                                    prechat: String? = nil,
                                    onlineStatusRequestFrequencyInMillis: Int64? = nil) -> SessionBuilder {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var sessionBuilder = Roxchat.newSessionBuilder()
            .set(appVersion: appVersion)
            .set(accountName: accountName)
            .set(location: location)
        if let multivisitorSection = multivisitorSection {
            sessionBuilder = sessionBuilder.set(multivisitorSection: multivisitorSection)
        }
        if let pageTitle = pageTitle {
            sessionBuilder = sessionBuilder.set(pageTitle: pageTitle)
        }
        if let providedAuthorizationTokenStateListener = providedAuthorizationTokenStateListener {
            sessionBuilder = sessionBuilder.set(providedAuthorizationTokenStateListener: providedAuthorizationTokenStateListener, providedAuthorizationToken: providedAuthorizationToken)
        }
        if remoteNotificationSystem != .none {
            sessionBuilder = sessionBuilder.set(remoteNotificationSystem: remoteNotificationSystem)
        }
        if let visitorDataClearingEnabled = visitorDataClearingEnabled {
            sessionBuilder = sessionBuilder.set(isVisitorDataClearingEnabled: visitorDataClearingEnabled)
        }
        if let visitorFields = visitorFields {
            sessionBuilder = sessionBuilder.set(visitorFieldsJSONString: visitorFields)
        }
        if let roxchatLogger = roxchatLogger {
            sessionBuilder = sessionBuilder.set(roxchatLogger: roxchatLogger, verbosityLevel: roxchatLoggerVerbosityLevel ?? .warning, availableLogTypes: availableLogTypes)
        }
        if let roxchatAlert = roxchatAlert {
            sessionBuilder = sessionBuilder.set(roxchatAlert: roxchatAlert)
        }
        if let prechat = prechat {
            sessionBuilder = sessionBuilder.set(prechat: prechat)
        }
        if let onlineStatusRequestFrequencyInMillis = onlineStatusRequestFrequencyInMillis {
            sessionBuilder = sessionBuilder.set(onlineStatusRequestFrequencyInMillis: onlineStatusRequestFrequencyInMillis)
        }
        return sessionBuilder
    }
    
    private func buildVisitorCellsConfig() -> WMCellsConfig {
        let textCellSubtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor : visitorMessageTextColour
        ]
        let textCellConfig = WMTextCellConfigBuilder()
            .set(backgroundColor: visitorMessageBubbleColour)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: 10)
            .set(subtitleAttributes: textCellSubtitleAttributes)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .build()
        
        let imageCellConfig = WMImageCellConfigBuilder()
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: 10)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .build()
        
        let fileCellTitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor : UIColor.white
        ]
        let fileCellSubtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor : visitorFileMessageTextColour
        ]
        let fileCellConfig = WMFileCellConfigBuilder()
            .set(backgroundColor: visitorMessageBubbleColour)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: 10)
            .set(titleAttributes: fileCellTitleAttributes)
            .set(subtitleAttributes: fileCellSubtitleAttributes)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .set(fileImage: downloadFileImage, for: .download)
            .set(fileImage: readyFileImage, for: .ready)
            .set(fileImage: uploadFileImage, for: .upload)
            .set(fileImage: errorFileImage, for: .error)
            .set(fileImageColor: .white, for: .download)
            .set(fileImageColor: .white, for: .ready)
            .set(fileImageColor: .white, for: .upload)
            .set(fileImageColor: .red, for: .error)
            .build()
        
        let visitorCellsConfig = WMCellsConfigBuilder()
            .set(textCellConfig: textCellConfig)
            .set(imageCellConfig: imageCellConfig)
            .set(fileCellConfig: fileCellConfig)
            .build()
        
        return visitorCellsConfig
    }
    
    private func buildOperatorCellsConfig() -> WMCellsConfig {
        let cellTitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor : roxchatCyan
        ]
        let textCellSubtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor : operatorMessageTextColour
        ]
        let textCellConfig = WMTextCellConfigBuilder()
            .set(backgroundColor: operatorMessageBubbleColour)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner])
            .set(cornerRadius: 10)
            .set(titleAttributes: cellTitleAttributes)
            .set(subtitleAttributes: textCellSubtitleAttributes)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .build()
        
        let imageCellConfig = WMImageCellConfigBuilder()
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: 10)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .build()
        
        let fileCellSubtitleAttribute: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor : operatorMessageTextColour
        ]
        let fileCellConfig = WMFileCellConfigBuilder()
            .set(backgroundColor: operatorMessageBubbleColour)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner])
            .set(cornerRadius: 10)
            .set(titleAttributes: cellTitleAttributes)
            .set(subtitleAttributes: fileCellSubtitleAttribute)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .set(fileImage: downloadFileImage, for: .download)
            .set(fileImage: readyFileImage, for: .ready)
            .set(fileImage: uploadFileImage, for: .upload)
            .set(fileImage: errorFileImage, for: .error)
            .set(fileImageColor: roxchatCyan, for: .download)
            .set(fileImageColor: roxchatCyan, for: .ready)
            .set(fileImageColor: roxchatCyan, for: .upload)
            .set(fileImageColor: .red, for: .error)
            .build()
        
        let operatorCellsConfig = WMCellsConfigBuilder()
            .set(textCellConfig: textCellConfig)
            .set(imageCellConfig: imageCellConfig)
            .set(fileCellConfig: fileCellConfig)
            .build()
        
        return operatorCellsConfig
    }

    private func chatViewControllerConfig() -> WMViewControllerConfig {
        let visitorCellsConfig = buildVisitorCellsConfig()
        let operatorCellsConfig = buildOperatorCellsConfig()
        
        let botButtonLabelAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor : botMessageTextColour
        ]
        let botButtonCellConfig = WMAbstractCellConfigBuilder()
            .set(backgroundColor: botMessageBubbleColour)
            .set(roundCorners: [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner,
                                .layerMaxXMaxYCorner,
                                .layerMinXMaxYCorner])
            .set(cornerRadius: 20)
            .set(subtitleAttributes: botButtonLabelAttributes)
            .set(strokeWidth: 1)
            .set(strokeColor: buttonBorderColor)
            .build()
        let toolBarConfig = WMToolbarConfigBuilder()
            .set(sendButtonImage: textInputButtonImage)
            .set(addAttachmentImage: fileButtonImage)
            .set(placeholderText: "Enter message")
            .set(textViewFont: .systemFont(ofSize: 16, weight: .regular))
            .set(textViewStrokeWidth: 1)
            .set(emptyTextViewStrokeColor: emptyBackgroundViewBorderColour)
            .set(filledTextViewStrokeColor: filledBackgroundViewBorderColour)
            .set(textViewCornerRadius: 17)
            .set(textViewMaxHeight: 90)
            .build()
        let networkErrorViewConfig = WMNetworkErrorViewConfigBuilder()
            .set(image: networkErrorView)
            .set(text: "Connection error")
            .set(backgroundColor: networkErrorViewBackgroundColour)
            .set(textColor: .white)
            .build()
        let replyCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: replyImage)
            .set(actionText: "Reply")
            .build()
        let copyCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: copyImage)
            .set(actionText: "Copy")
            .build()
        let editCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: editImage)
            .set(actionText: "Edit")
            .build()
        let deleteCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: deleteImage)
            .set(actionText: "Delete")
            .build()
        let likeCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: editImage)
            .set(actionText: "Like")
            .build()
        let dislikeCellConfig = defaultPopupCellConfigBuilder()
            .set(actionImage: editImage)
            .set(actionText: "Dislike")
            .build()
        let popupActionControllerConfig = WMPopupActionControllerConfigBuilder()
            .set(cornerRadius: 20)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
            .set(cellsHeight: 40)
            .set(cellConfig: replyCellConfig, for: .reply)
            .set(cellConfig: copyCellConfig, for: .copy)
            .set(cellConfig: editCellConfig, for: .edit)
            .set(cellConfig: deleteCellConfig, for: .delete)
            .set(cellConfig: likeCellConfig, for: .like)
            .set(cellConfig: dislikeCellConfig, for: .dislike)
            .build()
        let quoteViewConfig = WMQuoteViewConfigBuilder()
            .set(backgroundColor: .white)
            .set(quoteViewBackgroundColor: .white)
            .set(quoteTextColor: quoteMessageTextColour)
            .set(authorTextColor: quoteAuthorNameColour)
            .set(quoteTextFont: .systemFont(ofSize: 12, weight: .regular))
            .set(authorTextFont: .systemFont(ofSize: 14, weight: .bold))
            .set(quoteLineColor: quoteLineColour)
            .set(height: 71)
            .build()
        let editBarConfig = quoteViewConfig
        let surveyViewConfig = WMSurveyViewConfigBuilder()
            .set(title: rateOperatorTitle)
            .set(subtitle: rateOperatorSubtitle)
            .set(cosmosSettings: defaultCosmosSettings())
            .set(starsViewSize: CGSize(width: 170, height: 43))
            .set(buttonTitle: rateOperatorButtonTitle)
            .set(buttonColor: rateOperatorButtonColour)
            .set(buttonCornerRadius: 8)
            .build()
        let chatNavigationBarConfig = WMChatNavigationBarConfigBuilder()
            .set(backgroundColorOnlineState: navigationBarBarTintColour)
            .set(backgroundColorOfflineState: navigationBarNoConnectionColour)
            .set(textColorOnlineState: navigationBarTintColour)
            .set(textColorOfflineState: navigationBarTintColour)
            .set(logoImage: navigationBarTitleImageViewImage)
            .set(canShowTypingIndicator: true)
            .set(typingLabelText: "typing")
            .build()

        let chatConfig = WMChatViewControllerConfigBuilder()
            .set(showScrollButtonView: true)
            .set(scrollButtonImage: scrollButtonImage)
            .set(showScrollButtonCounter: true)
            .set(requestMessagesCount: 25)
            .set(refreshControlAttributedTitle: refreshControlAttributedTitle)
            .set(visitorCellsConfig: visitorCellsConfig)
            .set(operatorCellsConfig: operatorCellsConfig)
            .set(botButtonsConfig: botButtonCellConfig)
            .set(toolbarConfig: toolBarConfig)
            .set(networkErrorViewConfig: networkErrorViewConfig)
            .set(popupActionControllerConfig: popupActionControllerConfig)
            .set(quoteViewConfig: quoteViewConfig)
            .set(editBarConfig: editBarConfig)
            .set(surveyViewConfig: surveyViewConfig)
            .set(navigationBarConfig: chatNavigationBarConfig)
            .set(backgroundColor: chatTableViewBackgroundColour)
            .set(openFromNotification: true)
            .build()
        return chatConfig
    }

    private func imageViewControllerConfig() -> WMViewControllerConfig {
        let navigationConfig = WMImageNavigationBarConfigBuilder()
            .set(backgroundColorOnlineState: .clear)
            .set(backgroundColorOfflineState: .clear)
            .set(textColorOnlineState: .white)
            .set(textColorOfflineState: .white)
            .set(rightBarButtonImage: saveImageButton)
            .build()

        let imageViewControllerConfig = WMImageViewControllerConfigBuilder()
            .set(saveViewColor: roxchatCyan)
            .set(backgroundColor: .black)
            .set(navigationBarConfig: navigationConfig)
            .build()
        return imageViewControllerConfig
    }

    private func fileViewControllerConfig() -> WMViewControllerConfig {
        let navigationConfig = WMFileNavigationBarConfigBuilder()
            .set(backgroundColorOnlineState: navigationBarBarTintColour)
            .set(backgroundColorOfflineState: navigationBarNoConnectionColour)
            .set(textColorOnlineState: navigationBarTintColour)
            .set(textColorOfflineState: navigationBarTintColour)
            .set(rightBarButtonImage: fileShare)
            .build()

        let fileViewControllerConfig = WMFileViewControllerConfigBuilder()
            .set(backgroundColor: .clear)
            .set(loadingLabelText: loadingFileTitle)
            .set(canShowLoadingIndicator: true)
            .set(navigationBarConfig: navigationConfig)
            .build()
        return fileViewControllerConfig
    }
}

//MARK: Helper Methods
extension ExternalWidgetBuilder {
    private func defaultPopupCellConfigBuilder() -> WMPopupActionCellConfigBuilder {
        let subtitleAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .natural
                return paragraphStyle
            }(),
            .font : UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor : UIColor.white
        ]
        let popupCellConfig = WMPopupActionCellConfigBuilder()
            .set(backgroundColor: .clear)
            .set(roundCorners: [])
            .set(cornerRadius: 0)
            .set(subtitleAttributes: subtitleAttributes)
            .set(strokeWidth: 0)
            .set(strokeColor: .clear)
        return popupCellConfig
    }

    private func defaultCosmosSettings() -> CosmosSettings {
        var settings = CosmosSettings()
        settings.fillMode = .full
        settings.starSize = 30
        settings.filledColor = cosmosViewFilledColour
        settings.filledBorderColor = cosmosViewFilledBorderColour
        settings.emptyColor = cosmosViewEmptyColour
        settings.emptyBorderColor = cosmosViewEmptyBorderColour
        settings.emptyBorderWidth = 2
        return settings
    }
}

//MARK: Helper Fileprivate Properties
fileprivate let centerAligmentParagraphStyle = {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    return style
}()

fileprivate let refreshControlAttributedTitle = NSAttributedString(
    string: "Fetching more messages...",
    attributes: [NSAttributedString.Key.foregroundColor: refreshControlTextColour])

fileprivate let rateOperatorTitle = NSAttributedString(
    string: "Rate Operator",
    attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .semibold),
                 .foregroundColor : rateOperatorTitleColour,
                 .paragraphStyle : centerAligmentParagraphStyle])

fileprivate let rateOperatorSubtitle = NSAttributedString(
    string: "Please rate the overall impression of the consultation",
    attributes: [.font : UIFont.systemFont(ofSize: 15, weight: .regular),
                 .foregroundColor : rateOperatorSubtitleColour,
                 .paragraphStyle : centerAligmentParagraphStyle])

fileprivate let rateOperatorButtonTitle = NSAttributedString(
    string: "Send",
    attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .semibold),
                 .foregroundColor : UIColor.white,
                 .paragraphStyle : centerAligmentParagraphStyle])

fileprivate let loadingFileTitle = NSAttributedString(
    string: "Loading File...",
    attributes: [.font : UIFont.systemFont(ofSize: 17, weight: .regular),
                 .foregroundColor : UIColor.black,
                 .paragraphStyle : centerAligmentParagraphStyle])

