//
//  ColourConstants.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2019 Roxchat. All rights reserved.
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

// MARK: - Colours
fileprivate let CLEAR = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
fileprivate let WHITE = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
fileprivate let BLACK = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
fileprivate let LIGHT_GREY = #colorLiteral(red: 0.8823529412, green: 0.8901960784, blue: 0.9176470588, alpha: 1)
fileprivate let GREY = #colorLiteral(red: 0.4901960784, green: 0.4980392157, blue: 0.5843137255, alpha: 1)
fileprivate let NO_CONNECTION_GREY = #colorLiteral(red: 0.4784313725, green: 0.4941176471, blue: 0.5803921569, alpha: 1)
fileprivate let TRANSLUCENT_GREY = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
fileprivate let ROXCHAT_CYAN = #colorLiteral(red: 0.08675732464, green: 0.6737991571, blue: 0.8237424493, alpha: 1)
fileprivate let ROXCHAT_PUPRLE = #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.4196078431, alpha: 1)
fileprivate let ROXCHAT_DARK_PUPRLE = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3058823529, alpha: 1)
fileprivate let ROXCHAT_LIGHT_PURPLE = #colorLiteral(red: 0.4117647059, green: 0.4235294118, blue: 0.568627451, alpha: 1)
fileprivate let ROXCHAT_RED = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
fileprivate let ROXCHAT_GREY = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
fileprivate let ROXCHAT_LIGHT_BLUE = #colorLiteral(red: 0.9411764706, green: 0.9725490196, blue: 0.9843137255, alpha: 1)
fileprivate let ROXCHAT_LIGHT_CYAN = #colorLiteral(red: 0.02352941176, green: 0.5411764706, blue: 0.7058823529, alpha: 0.15)

// MARK: - Views' colour properties
// FlexibleTableViewCell.swift
let flexibleTableViewCellBackgroundColour = CLEAR
/// System
let messageBodyLabelColourSystem = ROXCHAT_LIGHT_PURPLE
let messageBackgroundViewColourSystem = LIGHT_GREY
let messageBackgroundViewColourClear = CLEAR
/// Visitor
let messageBodyLabelColourVisitor = WHITE
let messageBackgroundViewColourVisitor = ROXCHAT_CYAN
let documentFileNameLabelColourVisitor = WHITE
let documentFileDescriptionLabelColourVisitor = LIGHT_GREY
let documentIcomColor = #colorLiteral(red: 0.01960784314, green: 0.5411764706, blue: 0.7058823529, alpha: 1)
let quoteLineViewColourVisitor = WHITE
let quoteUsernameLabelColourVisitor = WHITE
let quoteBodyLabelColourVisitor = LIGHT_GREY
let visitorFileNameColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let visitorFileImageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let visitorFileDescriptionColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
/// Operator
let messageUsernameLabelColourOperator = ROXCHAT_CYAN
let messageBodyLabelColourOperator = ROXCHAT_DARK_PUPRLE
let messageBackgroundViewColourOperator = WHITE
let documentFileNameLabelColourOperator = ROXCHAT_DARK_PUPRLE
let documentFileDescriptionLabelColourOperator = GREY
let imageUsernameLabelColourOperator = WHITE
let imageUsernameLabelBackgroundViewColourOperator = ROXCHAT_GREY
let quoteLineViewColourOperator = ROXCHAT_CYAN
let quoteUsernameLabelColourOperator = ROXCHAT_DARK_PUPRLE
let operatorFileNameColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3176470588, alpha: 1)
let operatorFileImageColor = #colorLiteral(red: 0.08675732464, green: 0.6737991571, blue: 0.8237424493, alpha: 1)
let operatorFileDescriptionColor = #colorLiteral(red: 0.3607843137, green: 0.3725490196, blue: 0.5411764706, alpha: 0.5)
/// Other
let quoteBodyLabelColourOperator = GREY
let quoteBackgroundColor = ROXCHAT_LIGHT_BLUE
let dateLabelColour = GREY
let timeLabelColour = GREY
let messageStatusIndicatorColour = ROXCHAT_DARK_PUPRLE.cgColor
let documentFileStatusPercentageIndicatorColour = ROXCHAT_CYAN.cgColor
let buttonDefaultBackgroundColour = WHITE
let buttonChoosenBackgroundColour = #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.4196078431, alpha: 1)
let buttonCanceledBackgroundColour = WHITE
let buttonDefaultTitleColour = #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.4196078431, alpha: 1)
let buttonChoosenTitleColour = WHITE
let buttonCanceledTitleColour = #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.4196078431, alpha: 1)
let buttonBorderColor = #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.4196078431, alpha: 1)

// RateStarsViewController.swift
let cosmosViewFilledColour = ROXCHAT_CYAN
let cosmosViewFilledBorderColour = ROXCHAT_CYAN
let cosmosViewEmptyColour = LIGHT_GREY
let cosmosViewEmptyBorderColour = LIGHT_GREY

// PopupActionTableViewCell.swift
let actionColourCommon = WHITE
let actionColourDelete = ROXCHAT_RED

// ChatViewController.swift
/// Separator
let bottomBarSeparatorColour = TRANSLUCENT_GREY
/// Bottom bar
let bottomBarBackgroundViewColour = WHITE
let bottomBarQuoteLineViewColour = ROXCHAT_CYAN
let emptyBackgroundViewBorderColour = LIGHT_GREY
let filledBackgroundViewBorderColour = ROXCHAT_PUPRLE
/// Bottom bar for edit/reply
let textInputViewPlaceholderLabelTextColour = GREY
let textInputViewPlaceholderLabelBackgroundColour = CLEAR
let wmCoral = #colorLiteral(red: 0.7882352941, green: 0.3411764706, blue: 0.2196078431, alpha: 1)
/// MessageTextView
let linkColor = #colorLiteral(red: 0.1977989972, green: 0.5007162094, blue: 0.9563334584, alpha: 1)
/// WMQuoteView
let rawQuoteViewLabelColour = GREY
/// ScrollButtonView
let unreadMessagesBorderColour = LIGHT_GREY

// ChatTableViewController.swift
let refreshControlTextColour = ROXCHAT_DARK_PUPRLE
let refreshControlTintColour = ROXCHAT_DARK_PUPRLE

// ImageViewController.swift
// FileViewController.swift
let topBarTintColourDefault = ROXCHAT_DARK_PUPRLE
let topBarTintColourClear = CLEAR
let roxchatCyan = ROXCHAT_CYAN

// PopupActionViewController.swift
let popupBackgroundColour = CLEAR
let actionsTableViewBackgroundColour = BLACK
let actionsTableViewCellBackgroundColour = CLEAR

// SettingsViewController.swift
let backgroundViewColour = WHITE
let saveButtonBackgroundColour = ROXCHAT_CYAN
let saveButtonTitleColour = WHITE
let saveButtonBorderColour = BLACK.cgColor
let versionLabelFontColor = #colorLiteral(red: 0.4549019608, green: 0.5450980392, blue: 0.5882352941, alpha: 1)

// SettingsTableViewController.swift
let tableViewBackgroundColour = WHITE
let labelTextColour = ROXCHAT_DARK_PUPRLE
let textFieldTextColour = ROXCHAT_DARK_PUPRLE
let textFieldTintColour = ROXCHAT_DARK_PUPRLE
let editViewBackgroundColourEditing = ROXCHAT_CYAN
let editViewBackgroundColourError = ROXCHAT_RED
let editViewBackgroundColourDefault = GREY

// StartViewController.swift
let startViewBackgroundColour = ROXCHAT_DARK_PUPRLE
let navigationBarBarTintColour = ROXCHAT_DARK_PUPRLE
let navigationBarNoConnectionColour = NO_CONNECTION_GREY
let navigationBarTintColour = WHITE
let navigationBarClearColour = CLEAR
let welcomeLabelTextColour = WHITE
let welcomeTextViewTextColour = WHITE
let welcomeTextViewForegroundColour = ROXCHAT_CYAN
let startChatButtonBackgroundColour = ROXCHAT_CYAN
let startChatButtonBorderColour = ROXCHAT_CYAN.cgColor
let startChatTitleColour = WHITE
let settingsButtonTitleColour = WHITE
let settingButtonBorderColour = GREY.cgColor

// UITableView extension
let textMainColour = ROXCHAT_DARK_PUPRLE

// SurveyCommentViewController
let WMSurveyCommentPlaceholderColor = #colorLiteral(red: 0.6116228104, green: 0.6236780286, blue: 0.7096156478, alpha: 1)
// CircleProgressIndicator
let WMCircleProgressIndicatorLightGrey = LIGHT_GREY
let WMCircleProgressIndicatorCyan = ROXCHAT_CYAN

let wmGreyMessage = #colorLiteral(red: 0.6116228104, green: 0.6236780286, blue: 0.7096156478, alpha: 1).cgColor
let wmLayerColor = #colorLiteral(red: 0.1490196078, green: 0.1960784314, blue: 0.2196078431, alpha: 1).cgColor
let wmInfoCell = ROXCHAT_LIGHT_CYAN.cgColor

// FileMessage
let defaultFileImageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let defaultFileNameColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let defaultFileDescriptionColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)

// WMQuoteFileCell
let quoteFileVisitorMessageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let quoteFileOperatorMessageTextColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3176470588, alpha: 1)

// WMQuoteImageCell
let quoteImageVisitorMessageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let quoteImageOperatorMessageTextColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3176470588, alpha: 1)

// WMQuoteMessageCell
let quoteVisitorMessageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let quoteOperatorMessageTextColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3176470588, alpha: 1)

// WMOperatorMessageCell
let operatorMessageCellTextColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3176470588, alpha: 1)

// WMVisitorMessageCell
let visitorMessageCellTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

// WMInfoMessageCell
let infoMessageCellTextColor = #colorLiteral(red: 0.3607843137, green: 0.3725490196, blue: 0.5411764706, alpha: 1)

// WMNewMessageView
let newMessageTextColor = #colorLiteral(red: 0.1529411765, green: 0.1647058824, blue: 0.3176470588, alpha: 1)
let newMessageBorderColor = #colorLiteral(red: 0.7882352941, green: 0.8, blue: 0.8666666667, alpha: 0.6)
