//
//  WMImageQuoteTableViewCell.swift
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
import Nuke

class WMQuoteImageCell: WMMessageTableCell, WMFileDownloadProgressListener {
    
    @IBOutlet var messageTextView: UITextView!
    
    @IBOutlet var quoteMessageText: UILabel!
    @IBOutlet var quoteAuthorName: UILabel!
    
    @IBOutlet var quoteImage: UIImageView!
    var url: URL?
    var animatedImage: ImageContainer?

    override func setMessage(message: Message) {
        super.setMessage(message: message)
        self.quoteImage.image = placeholderImage
        self.quoteMessageText.text = "Image".localized
        self.quoteAuthorName.text = message.getQuote()?.getSenderName()
        
        if let attachment = message.getQuote()?.getMessageAttachment(), let url = WMDownloadFileManager.shared.urlFromFileInfo(attachment) {
            self.url = url
            WMFileDownloadManager.shared.subscribeForImage(url: url, progressListener: self)
        }
        let textColor = message.isVisitorType() ? quoteImageVisitorMessageTextColor : quoteImageOperatorMessageTextColor
        let _ = self.messageTextView.setTextWithReferences(message.getText(), textColor: textColor, alignment: .left)
        for recognizer in messageTextView.gestureRecognizers ?? [] {
            if recognizer.isKind(of: UIPanGestureRecognizer.self) {
                recognizer.isEnabled = false
            }
        }
    }
    
    func progressChanged(url: URL, progress: Float, image: ImageContainer?, error: Error?) {
        if url != self.url {
            return
        }
        guard error == nil else {
            WMFileDownloadManager.shared.addDamagedImageMessage(id: message.getID())
            return
        }
        if let image = image {
            self.quoteImage.image = image.image
            self.animatedImage = image
        } else {
            self.quoteImage.image = placeholderImage
        }
    }
    
    @objc func imageViewTapped() {
        self.delegate?.imageViewTapped(message: self.message, image: self.animatedImage ?? (self.quoteImage.image != nil  ? ImageContainer(image: self.quoteImage.image!) : nil), url: self.url)
    }

    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        if setup {
            let imageTapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(imageViewTapped)
            )

            self.sharpCorner(view: messageView, visitor: true)
            self.quoteImage.gestureRecognizers = nil
            self.quoteImage.addGestureRecognizer(imageTapGestureRecognizer)
        }
        return setup
    }
}

class TextMessage: WMMessageTableCell {
    @IBOutlet var messageLabel: UILabel!
}
