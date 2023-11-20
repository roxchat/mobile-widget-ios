//
//  WMQuoteView.swift
//  Roxchat
//
//  Copyright © 2021 _roxchat_. All rights reserved.
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
import Nuke
import RoxchatClientLibrary

enum WMQuoteViewMode {
    case quote
    case edit
}

protocol WMQuoteViewDelegate: AnyObject {
    func removeQuoteEditBar()
}

class WMQuoteView: UIView, URLSessionDelegate {
    var fileSize: Int64 = 0
    var fileURL: URL?
    var originText: String?
    
    var quoteConfig: WMHelperInputViewConfig?
    var editBarConfig: WMHelperInputViewConfig?
    
    weak var quoteViewDelegate: WMQuoteViewDelegate?
    weak var delegate: WMDialogCellDelegate?
    
    @IBOutlet private var quoteView: UIView!
    @IBOutlet var quoteImageView: UIImageView!
    @IBOutlet private var quoteMessageText: UILabel!
    @IBOutlet private var quoteAuthorName: UILabel!
    @IBOutlet private var quoteLine: UIView!
    @IBOutlet private var fileStatus: UIButton!
    
    @IBOutlet private var leftMessageToLineConstraint: NSLayoutConstraint!
    @IBOutlet private var leftAuthorToLineConstraint: NSLayoutConstraint!
    @IBOutlet private var leftMessageToImageConstraint: NSLayoutConstraint!
    @IBOutlet private var leftAuthorToImageConstraint: NSLayoutConstraint!
    @IBOutlet private var leftImageToLineConstraint: NSLayoutConstraint!
    @IBOutlet private var leftMessageToFileConstraint: NSLayoutConstraint!
    @IBOutlet private var leftAuthorToFileConstraint: NSLayoutConstraint!
    @IBOutlet private var leftFileToLineConstraint: NSLayoutConstraint!
    @IBOutlet private var aspectFileStatusConstraint: NSLayoutConstraint!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!

    var currentMessage: String {
        return quoteMessageText.text ?? ""
    }
    
    var currentMode: WMQuoteViewMode {
        return mode
    }
    
    private var mode = WMQuoteViewMode.quote
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(bounds.size)
    }
    
    @IBAction private func removeQuoteEditBar(_ sender: Any) {
        if mode == .edit {
            self.delegate?.cleanTextView()
        }
        quoteViewDelegate?.removeQuoteEditBar()
    }
    
    func addEditBarForMessage(_ message: Message, delegate: WMDialogCellDelegate) {
        mode = WMQuoteViewMode.edit
        self.delegate = delegate
        self.setupTextQuoteMessage(quoteText: message.getText(), quoteAuthor: String.unwarpOrEmpty(message.getSenderName()), fromOperator: message.isOperatorType())
        adjustConfig(for: mode)
    }
    
    func addQuoteBarForMessage(_ message: Message, delegate: WMDialogCellDelegate) {
        self.delegate = delegate
        mode = WMQuoteViewMode.quote
        if message.isText() {
            self.setupTextQuoteMessage(quoteText: message.getText(), quoteAuthor: message.getSenderName(), fromOperator: message.isOperatorType())
        } else if message.isFile() {
            guard let fileInfo = message.getData()?.getAttachment()?.getFileInfo(), let quoteState = message.getData()?.getAttachment()?.getState() else {
                return
            }
            if let imageURL = fileInfo.getImageInfo()?.getThumbURL() {
                self.setupImageQuoteMessage(quoteAuthor: message.getSenderName(), url: imageURL, fileInfo: fileInfo, fromOperator: message.isOperatorType())
            } else if let fileURL = fileInfo.getURL() {
                self.setupFileQuoteMessage(quoteText: fileInfo.getFileName(), quoteAuthor: message.getSenderName(), url: fileURL, fileInfo: fileInfo, quoteState: quoteState, openFileDelegate: delegate, fromOperator: message.isOperatorType())
            }
        }
        adjustConfig(for: mode)
    }
    
    func setup(_ quoteText: String, _ quoteAuthor: String, _ fromOperator: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.originText = quoteText
        self.quoteMessageText.text = originText?.oneLineString()
        self.quoteAuthorName.text = fromOperator ? quoteAuthor : "You".localized
        quoteView.layer.cornerRadius = 10
        quoteView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        switch mode {
        case .quote:
            quoteAuthorName.text = quoteAuthor
        case .edit:
            quoteAuthorName.text = "Edit Message".localized
        }
    }
    
    func setupTextQuoteMessage(quoteText: String, quoteAuthor: String, fromOperator: Bool) {
        setup(quoteText, quoteAuthor, fromOperator)
        quoteImageView.isHidden = true
        fileStatus.isHidden = true
        
        NSLayoutConstraint.deactivate(getConstraintForImageQuote())
        NSLayoutConstraint.deactivate(getConstraintForFileQuote())
        NSLayoutConstraint.activate(getConstraintForTextQuote())
    }
    
    func setupImageQuoteMessage(quoteAuthor: String, url: URL, fileInfo: FileInfo, fromOperator: Bool) {
        setup("Image".localized, quoteAuthor, fromOperator)
        fileStatus.isHidden = true
        quoteImageView.isHidden = false
        quoteImageView.accessibilityIdentifier = url.absoluteString
        let request = ImageRequest(url: url)
        NSLayoutConstraint.deactivate(getConstraintForFileQuote())
        NSLayoutConstraint.deactivate(getConstraintForTextQuote())
        NSLayoutConstraint.activate(getConstraintForImageQuote())
        
        if let imageContainer = ImageCache.shared[ImageCacheKey(request: request)] {
            self.quoteImageView.image = imageContainer.image
        } else {
            requestImage(with: url)
        }
    }
    
    func setupFileQuoteMessage(quoteText: String, quoteAuthor: String, url: URL, fileInfo: FileInfo, quoteState: AttachmentState, openFileDelegate: WMDialogCellDelegate, fromOperator: Bool) {
        setup(quoteText, quoteAuthor, fromOperator)
        quoteImageView.isHidden = true
        fileStatus.isHidden = false
        fileURL = url
        fileSize = fileInfo.getSize() ?? 0
        
        NSLayoutConstraint.deactivate(getConstraintForTextQuote())
        NSLayoutConstraint.deactivate(getConstraintForImageQuote())
        NSLayoutConstraint.activate(getConstraintForFileQuote())
    }
    
    override func loadXibViewSetup() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        layer.addSublayer(topBorder)
    }
    
    private func adjustConfig(for mode: WMQuoteViewMode) {
        var config: WMHelperInputViewConfig?
        switch mode {
        case .quote:
            config = quoteConfig
        case .edit:
            config = editBarConfig
        }
        
        guard let config = config else {
            adjustDefaultConfig()
            return
        }
        
        if let backgroundColor = config.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if let quoteViewBackgroundColor = config.quoteViewBackgroundColor {
            self.quoteView.backgroundColor = quoteViewBackgroundColor
        }
        
        if let quoteTextColor = config.quoteTextColor {
            quoteMessageText.textColor = quoteTextColor
        }
        
        if let authorTextColor = config.authorTextColor {
            quoteAuthorName.textColor = authorTextColor
        }
        
        if let quoteTextFont = config.quoteTextFont {
            quoteMessageText.font = quoteTextFont
        }
        
        if let authorTextFont = config.authorTextFont {
            quoteAuthorName.font = authorTextFont
        }
        
        if let quoteLineColor = config.quoteLineColor {
            quoteLine.backgroundColor = quoteLineColor
        }
        
        if let height = config.height {
            heightConstraint.constant = height
        }
        
        //        leftImageConstraint.constant = 8
        //        rightImageConstraint.constant = 10
    }
    
    private func adjustDefaultConfig() {
        quoteView.backgroundColor = .white
        backgroundColor = .white
        quoteMessageText.textColor = UIColor(red: 0.15, green: 0.16, blue: 0.32, alpha: 0.60)
        quoteAuthorName.textColor = UIColor(red: 0.15, green: 0.16, blue: 0.32, alpha: 1.00)
        quoteMessageText.font = .systemFont(ofSize: 12, weight: .regular)
        quoteAuthorName.font = .systemFont(ofSize: 14, weight: .bold)
        quoteLine.backgroundColor = UIColor(red: 0.08, green: 0.67, blue: 0.82, alpha: 1.00)
    }
    
    private func getConstraintForTextQuote() -> [NSLayoutConstraint] {
        return [
            leftMessageToLineConstraint,
            leftAuthorToLineConstraint
        ]
    }
    
    private func getConstraintForImageQuote() -> [NSLayoutConstraint] {
        return [
            leftMessageToImageConstraint,
            leftAuthorToImageConstraint,
            leftImageToLineConstraint
        ]
    }
    
    private func getConstraintForFileQuote() -> [NSLayoutConstraint] {
        return [
            leftMessageToFileConstraint,
            leftAuthorToFileConstraint,
            leftFileToLineConstraint,
            aspectFileStatusConstraint
        ]
    }
    
    private func requestImage(with url: URL) {
        let request = ImageRequest(url: url)
        Nuke.ImagePipeline.shared.loadImage(with: url, completion:  { [weak self] _ in
            guard let self = self else { return }
            self.quoteImageView.image = ImageCache.shared[ImageCacheKey(request: request)]?.image
        })
    }
}

extension WMQuoteView: WMFileDownloadProgressListener {
    func progressChanged(url: URL, progress: Float, image: ImageContainer?, error: Error?) {
        guard error == nil else {
            quoteImageView.image = fileDownloadButtonImage
            return
        }
        quoteImageView.image = image?.image ?? .loadImageFromWidget(named: "placeholder")
    }
}
