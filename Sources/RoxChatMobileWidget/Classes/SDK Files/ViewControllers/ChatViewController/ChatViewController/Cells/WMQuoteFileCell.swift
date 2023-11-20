//
//  WMFileQuoteTableViewCell.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2021 Roxchat. All rights reserved.
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
import RoxchatClientLibrary

class WMQuoteFileCell: FileMessage {
    @IBOutlet var messageTextView: UITextView!
    
    @IBOutlet var quoteAuthorName: UILabel!
    @IBOutlet var quoteMessageText: UILabel!
    
    override func setMessage(message: Message) {
        super.setMessage(message: message)
        
        self.isForOperator = true
        var fileSize: Int64 = -1
        
        if let attachment = message.getQuote()?.getMessageAttachment(),
           let fileURL = attachment.getURL() {
            fileSize = attachment.getSize() ?? -1
            self.documentDownloadTask = WMDocumentDownloadTask.documentDownloadTaskFor(url: fileURL, fileSize: fileSize, delegate: self)
        }
        self.quoteAuthorName.text = message.getQuote()?.getSenderName()
        let textColor = message.isVisitorType() ? quoteFileVisitorMessageTextColor : quoteFileOperatorMessageTextColor
        let _ = self.messageTextView.setTextWithReferences(message.getText(), textColor: textColor, alignment: .left)
        self.messageTextView.isUserInteractionEnabled = true
        for recognizer in messageTextView.gestureRecognizers ?? [] {
            if recognizer.isKind(of: UIPanGestureRecognizer.self) {
                recognizer.isEnabled = false
            }
        }
        self.quoteMessageText?.text = message.getQuote()?.getMessageAttachment()?.getFileName()
        
        self.fileDownloadIndicator?.isHidden = true
        self.downloadStatusLabel?.text = ""

        switch message.getSendStatus() {
        case .sent:
            resetFileStatus()
        case .sending:
            self.fileDescription?.text = "Sending".localized
            setupFileStatusImage()
            self.fileStatus.isUserInteractionEnabled = false
        }
    }
    
    @objc override func resetFileStatus() {
        self.fileStatus.isHidden = false
        self.downloadStatusLabel?.text = ""
        self.fileDownloadIndicator?.isHidden = true
        let fileName = message.getQuote()?.getMessageAttachment()?.getFileName()
        setupFileStatusImage()
        self.fileDescription?.text = fileName
        self.fileStatus.isUserInteractionEnabled = false
    }
    
    override func updateFileDownloadProgress(
        downloadFileUrl: URL,
        progress: Float,
        localFileUrl: URL?
    ) { }
    
    private func setupFileStatusImage() {
        let fileImageColor = message.isVisitorType() ? defaultFileImageColor : roxchatCyan
        let fileImage = documentDownloadTask?.isFileExist() ?? false ? fileDownloadSuccessImage : fileDownloadButtonImage
        self.fileStatus.setBackgroundImage(fileImage?.colour(fileImageColor), for: .normal)
    }
    
}
