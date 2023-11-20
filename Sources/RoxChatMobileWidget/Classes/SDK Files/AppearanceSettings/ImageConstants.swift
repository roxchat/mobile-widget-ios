//
//  ImageConstants.swift
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

// ChatViewController.swift
let loadingPlaceholderImage: UIImage! = .loadImageFromWidget(named: "ImagePlaceholder")
let navigationBarTitleImageViewImage: UIImage! = .loadImageFromWidget(named: "LogoRoxchatNavigationBar_dark")
let scrollButtonImage: UIImage! = .loadImageFromWidget(named: "SendMessageButton")?.flipImage(.vertically)
let textInputButtonImage: UIImage! = .loadImageFromWidget(named: "SendMessageButton")?.flipImage(.vertically)

// ChatTableViewController.swift
private let privateReplyImage: UIImage! = .loadImageFromWidget(named: "ReplyCircleToTheLeft")
private let privateFlippedReplyImage: UIImage! = .loadImageFromWidget(named: "ReplyCircleToTheLeft")?.flipImage(.horizontally)
let leadingSwipeActionImage: UIImage! = privateFlippedReplyImage
let trailingSwipeActionImage: UIImage! = privateReplyImage

// ImageViewController.swift
let saveButtonImage: UIImage! = .loadImageFromWidget(named: "ImageDownload")
let fileShare: UIImage! = .loadImageFromWidget(named: "FileShare")

// PopupActionTableViewCell.swift
let replyImage: UIImage! = .loadImageFromWidget(named: "ActionReply")
let copyImage: UIImage! = .loadImageFromWidget(named: "ActionCopy")
let editImage: UIImage! = .loadImageFromWidget(named: "ActionEdit")
let deleteImage: UIImage! = .loadImageFromWidget(named: "ActionDelete")?.colour(actionColourDelete)

// SurveyRadioButtonViewController.swift
let selectedSurveyPoint: UIImage! = .loadImageFromWidget(named: "selectedSurveyPoint")
let unselectedSurveyPoint: UIImage! = .loadImageFromWidget(named: "unselectedSurveyPoint")


// WMFileTableViewCell.swift
let fileDownloadSuccessImage: UIImage! = .loadImageFromWidget(named: "FileDownloadSuccess")
let fileDownloadButtonImage: UIImage! = .loadImageFromWidget(named: "FileDownloadButton")
let fileUploadButtonVisitorImage: UIImage! = .loadImageFromWidget(named: "FileUploadButtonVisitor")
let fileDownloadErrorImage: UIImage! = .loadImageFromWidget(named: "FileDownloadError")

// WMQuoteImageCell.swift
let placeholderImage: UIImage! = .loadImageFromWidget(named: "placeholder")

