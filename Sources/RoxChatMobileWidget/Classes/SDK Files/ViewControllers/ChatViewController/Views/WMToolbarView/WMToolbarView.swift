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

class WMToolbarView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    var quoteView = WMQuoteView.loadXibView()
    var messageView = WMNewMessageView.loadXibView()
    
    var heightConstraint: NSLayoutConstraint?
    var quoteViewTopConstraint: NSLayoutConstraint?

    var config: WMToolbarConfig?

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

    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        messageView.frame.size.width = self.frame.size.width
        self.addSubview(messageView)
        
        self.bindWidthToSuperview()
        self.bindHeightToSuperview()
        
        messageView.bindWidthToSuperview()

        let messageViewBottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(messageViewBottomConstraint)

        self.heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        self.addConstraint(heightConstraint!)
    }

    func adjustConfig() {
        if let sendButtonImage = config?.sendButtonImage {
            messageView.sendButton.setImage(sendButtonImage, for: .normal)
        }
        
        if let inactiveSendButtonImage = config?.inactiveSendButtonImage {
            messageView.sendButton.setImage(inactiveSendButtonImage, for: .disabled)
        }

        if let addAttachmentImage = config?.addAttachmentImage {
            messageView.fileButton.setImage(addAttachmentImage, for: .normal)
        }

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

        messageView.adjustConfig()
    }
    
    func showHideTooltipsView() -> Bool {
        return  UIDevice.current.orientation.isLandscape &&
                UIDevice.current.userInterfaceIdiom == .phone &&
                self.quoteView.superview != nil
    }
    
    func addQuoteEditBarForMessage(_ message: Message?, delegate: WMDialogCellDelegate) {
        if let message = message {
            self.quoteView.addQuoteEditBarForMessage(message, delegate: delegate)
            self.addSubview(quoteView)
            
            self.messageView.setMessageText(message.getText())

            quoteView.bindWidthToSuperview()
            
            self.quoteViewTopConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: quoteView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            self.addConstraint(self.quoteViewTopConstraint!)
            self.setNeedsLayout()
        } else {
            self.quoteView.removeFromSuperview()
        }
    }
    
    func addQuoteBarForMessage(_ message: Message?, delegate: WMDialogCellDelegate) {
        if let message = message {
            self.quoteView.addQuoteBarForMessage(message, delegate: delegate)
            self.addSubview(quoteView)

            quoteView.bindWidthToSuperview()
            
            self.quoteViewTopConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: quoteView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            self.addConstraint(self.quoteViewTopConstraint!)
            self.setNeedsLayout()
        } else {
            self.quoteView.removeFromSuperview()
        }
    }
    
    func removeQuoteEditBar() {
        self.quoteView.quoteViewWillRemove()
        self.quoteView.removeFromSuperview()
    }
    
    func quoteBarIsVisible() -> Bool {
        return quoteView.superview != nil
    }
}
