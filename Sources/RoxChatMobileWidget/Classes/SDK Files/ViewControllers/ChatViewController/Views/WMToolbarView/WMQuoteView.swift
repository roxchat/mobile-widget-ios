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
    func cleanTextView()
}

class WMQuoteView: UIView, URLSessionDelegate {
    @IBOutlet var quoteView: UIView!
    @IBOutlet var quoteMessageText: UILabel!
    @IBOutlet var quoteAuthorName: UILabel!
    @IBOutlet var quoteImageView: UIImageView!
    @IBOutlet var quoteLine: UIView!
    @IBOutlet var fileDownloadIndicator: CircleProgressIndicator!
    @IBOutlet var downloadStatusLabel: UILabel!

    @IBOutlet var heightConstraint: NSLayoutConstraint!

    var fileSize: Int64 = 0
    var fileURL: URL?
    var originText: String?
    var previousHeight: CGFloat = 0.0
    var quoteConfig: WMHelperInputViewConfig?
    var editBarConfig: WMHelperInputViewConfig?

    weak var delegate: WMDialogCellDelegate?

    private var mode = WMQuoteViewMode.quote

    override func layoutSubviews() {
        super.layoutSubviews()
        if previousHeight != bounds.height {
            previousHeight = bounds.height
        }
    }

    func quoteViewWillRemove() {
        previousHeight = .zero
    }
    
    func currentMessage() -> String {
        return originText ?? ""
    }
    
    func currentMode() -> WMQuoteViewMode {
        return mode
    }
    
    func addQuoteEditBarForMessage(_ message: Message, delegate: WMDialogCellDelegate) {
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
        self.quoteView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            self.quoteView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
    func setupTextQuoteMessage(quoteText: String, quoteAuthor: String, fromOperator: Bool) {
        self.setup(quoteText, quoteAuthor, fromOperator)
        self.quoteImageView.isHidden = true
        self.quoteImageView.removeConstraints(quoteImageView.constraints)
        self.quoteMessageText.leftAnchor.constraint(equalTo: self.quoteLine.rightAnchor, constant: 12.0).isActive = true
        self.quoteAuthorName.leftAnchor.constraint(equalTo: self.quoteLine.rightAnchor, constant: 12.0).isActive = true
    }
    
    func setupImageQuoteMessage(quoteAuthor: String, url: URL, fileInfo: FileInfo, fromOperator: Bool) {
        self.setup("Image".localized, quoteAuthor, fromOperator)
        self.quoteImageView.isHidden = false
        DispatchQueue.main.async {
            self.updateQuoteImageViewConstraints()
        }
        self.quoteImageView.accessibilityIdentifier = url.absoluteString
        let request = ImageRequest(url: url)
        if let imageContainer = ImageCache.shared[ImageCacheKey(request: request)] {
            self.quoteImageView.image = imageContainer.image
        } else {
            WMFileDownloadManager.shared.subscribeForImage(url: url, progressListener: self)
        }
    }
    
    func setupFileQuoteMessage(quoteText: String, quoteAuthor: String, url: URL, fileInfo: FileInfo, quoteState: AttachmentState, openFileDelegate: WMDialogCellDelegate, fromOperator: Bool) {
        self.setup(quoteText, quoteAuthor, fromOperator)
        self.quoteImageView.isHidden = false
        DispatchQueue.main.async {
            self.updateQuoteImageViewConstraints()
        }
        self.fileURL = url
        self.fileSize = fileInfo.getSize() ?? 0
        self.quoteImageView.image = .loadImageFromWidget(named: "FileDownloadButton")
    }
    
    override func loadXibViewSetup() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        layer.addSublayer(topBorder)
    }
    
    @IBAction func removeQuoteEditBar() {
        if mode == .edit {
            self.delegate?.cleanTextView()
        }
        self.quoteViewWillRemove()
        self.removeFromSuperview()
    }

    private func updateQuoteImageViewConstraints() {
        quoteMessageText.leftAnchor.constraint(equalTo: self.quoteImageView.rightAnchor, constant: 10.0).isActive = true
        quoteAuthorName.leftAnchor.constraint(equalTo: self.quoteImageView.rightAnchor, constant: 10.0).isActive = true
        quoteImageView.leftAnchor.constraint(equalTo: self.quoteLine.rightAnchor, constant: 8.0).isActive = true
        quoteImageView.heightAnchor.constraint(equalTo: self.quoteImageView.widthAnchor).isActive = true
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
    }

    private func adjustDefaultConfig() {
        quoteView.backgroundColor = .white
        backgroundColor = .white
        quoteMessageText.textColor = UIColor(red: 0.15, green: 0.16, blue: 0.32, alpha: 0.60)
        quoteAuthorName.textColor = UIColor(red: 0.15, green: 0.16, blue: 0.32, alpha: 1.00)
        quoteMessageText.font = .systemFont(ofSize: 12, weight: .regular)
        quoteAuthorName.font = .systemFont(ofSize: 14, weight: .bold)
        quoteLine.backgroundColor = UIColor(red: 0.08, green: 0.67, blue: 0.82, alpha: 1.00)
        heightConstraint.constant = 71
    }
}

extension WMQuoteView: WMFileDownloadProgressListener {
    func progressChanged(url: URL, progress: Float, image: Nuke.ImageContainer?, error: Error?) {
        guard error == nil else {
            quoteImageView.image = fileDownloadButtonImage
            return
        }
        quoteImageView.image = image?.image ?? .loadImageFromWidget(named: "placeholder")
    }
}
