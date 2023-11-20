//
//  WMToolbarView.swift
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
import RoxchatClientLibrary
import SnapKit

class WMToolbarView: UIView {
    
    lazy var quoteView = WMQuoteView.loadXibView()
    lazy var messageView = WMNewMessageView.loadXibView()
    
    var config: WMToolbarConfig?
    var heightConstraint: NSLayoutConstraint?
    var quoteViewTopConstraint: NSLayoutConstraint?
    private var quoteViewBottomConstraint: Constraint!
    private var editButtonUIImage: UIImage = editButtonImage
    private var sendButtonUIImage: UIImage = sendButtonImage
    
    private var quoteViewVisible: Bool = false {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        recountIntrinsicContentSize()
    }

    override func layoutSubviews() {
        var additionalHeight: CGFloat = 0.0
        let quoteViewPosition: CGFloat = 0.0

        if self.quoteView.superview != nil {
            additionalHeight += self.quoteView.frame.height
        }

        if let quoteViewTopConstraint = self.quoteViewTopConstraint {
            if quoteViewTopConstraint.constant != quoteViewPosition {
                quoteViewTopConstraint.constant = quoteViewPosition
            }
        }

        if self.heightConstraint?.constant != additionalHeight {
            self.heightConstraint?.constant = additionalHeight
        }
        super.layoutSubviews()
    }

    override func loadXibViewSetup() {
        self.autoresizingMask = .flexibleHeight
        self.backgroundColor = .clear

        self.translatesAutoresizingMaskIntoConstraints = false
        self.quoteView.quoteViewDelegate = self

        self.setupViewHierarchy()
        self.setupViewConstraints()
    }
    
    private func setupViewHierarchy() {
        addSubview(quoteView)
        addSubview(messageView)
    }

    private func setupViewConstraints() {
        messageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        quoteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            quoteViewBottomConstraint = make.bottom.equalTo(messageView.snp.top).inset(quoteView.bounds.height).constraint
        }
    }

    func adjustConfig() {
        sendButtonUIImage = config?.sendButtonImage ?? sendButtonImage
        messageView.sendButton.setImage(sendButtonImage, for: .normal)
        
        let inactiveSendButtonImage = config?.inactiveSendButtonImage ?? sendInactiveButtonImage
        messageView.sendButton.setImage(inactiveSendButtonImage, for: .disabled)

        let addAttachmentImage = config?.addAttachmentImage ?? addAttachmentImage
        messageView.fileButton.setImage(addAttachmentImage, for: .normal)
        
        editButtonUIImage = config?.editButtonImage ?? editButtonImage

        if let placeholderText = config?.placeholderText {
            messageView.messagePlaceholder.text = placeholderText
        }

        if let textViewFont = config?.textViewFont {
            messageView.messageText.font = textViewFont
            messageView.messagePlaceholder.font = textViewFont
        }

        if let textViewStrokeWidth = config?.textViewStrokeWidth {
            messageView.set(textViewStrokeWidth: textViewStrokeWidth)
        }

        if let textViewCornerRadius = config?.textViewCornerRadius {
            messageView.set(textViewCornerRadius: textViewCornerRadius)
        }

        if let emptyTextViewStrokeColor = config?.emptyTextViewStrokeColor {
            messageView.emptyTextViewStrokeColor = emptyTextViewStrokeColor
        }

        if let filledTextViewStrokeColor = config?.filledTextViewStrokeColor {
            messageView.filledTextViewStrokeColor = filledTextViewStrokeColor
        }

        if let textViewMaxHeight = config?.textViewMaxHeight {
            WMNewMessageView.maxInputTextViewHeight = textViewMaxHeight
        }
        
        if let toolbarBackgroundColor = config?.toolbarBackgroundColor {
            messageView.backgroundColor = toolbarBackgroundColor
        }
        
        if let inputViewColor = config?.inputViewColor {
            messageView.messageText.backgroundColor = inputViewColor
        }
        
        if let placeholderColor = config?.placeholderColor {
            messageView.placeholderTextColor = placeholderColor
        }
        
        if let textViewTextColor = config?.textViewTextColor {
            messageView.textViewTextColor = textViewTextColor
        }
        
        messageView.adjustConfig()
    }
    
    func isQuoteViewVisible() -> Bool {
        quoteViewVisible
    }
    
    func setupSendButton(isEdit: Bool) {
        let sendButtonImage = isEdit ? editButtonUIImage : sendButtonUIImage
        messageView.sendButton.setImage(sendButtonImage, for: .normal)
    }
    
    func addEditBarForMessage(_ message: Message?, delegate: WMDialogCellDelegate) {
        guard let message = message else {
            removeQuoteEditBar()
            return
        }
        setupSendButton(isEdit: true)
        quoteView.addEditBarForMessage(message, delegate: delegate)
        messageView.setMessageText(message.getText())
        animateAddQuoteEditBar()
    }

    func addQuoteBarForMessage(_ message: Message?, delegate: WMDialogCellDelegate) {
        guard let message = message else {
            removeQuoteEditBar()
            return
        }

        quoteView.addQuoteBarForMessage(message, delegate: delegate)
        animateAddQuoteEditBar()
    }
    
    private func animateAddQuoteEditBar() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.quoteViewBottomConstraint.update(inset: 0)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }

        DispatchQueue.main.async {
            self.quoteViewVisible = true
        }
    }
    
    private func recountIntrinsicContentSize() -> CGSize {
        var resultSize = CGSize(width: bounds.width, height: 0)
        resultSize.height += messageView.frame.height

        if quoteViewVisible {
            resultSize.height += quoteView.intrinsicContentSize.height
        }

        return resultSize
    }
}

extension WMToolbarView: WMQuoteViewDelegate {
    func removeQuoteEditBar() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.quoteViewBottomConstraint.update(inset: self.quoteView.bounds.height)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }

        DispatchQueue.main.async {
            self.setupSendButton(isEdit: false)
            self.quoteViewVisible = false
        }
    }
}
