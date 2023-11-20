//
//  WMNewMessageView.swift
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

import Foundation
import UIKit
import RoxchatClientLibrary

protocol WMNewMessageViewDelegate: AnyObject {
    func inputTextChanged()
    func sendMessage()
    func showSendFileMenu(_ sender: UIButton)
}

class WMNewMessageView: UIView {
    
    static var maxInputTextViewHeight: CGFloat = 90
    static var initialInputTextViewHeight: CGFloat = 36

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var messagePlaceholder: UILabel!
    @IBOutlet weak var fileButton: UIButton!
    
    @IBOutlet private var inputTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet private var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var textViewTopConstraint: NSLayoutConstraint!
    
    weak var delegate: WMNewMessageViewDelegate?

    var emptyTextViewStrokeColor = emptyBackgroundViewBorderColour
    var filledTextViewStrokeColor = filledBackgroundViewBorderColour
    var placeholderTextColor = textInputViewPlaceholderLabelTextColour
    var textViewTextColor = newMessageTextColor

    override func loadXibViewSetup() {
        messageText.layer.cornerRadius = 17
        messageText.layer.borderWidth = 1
        messageText.layer.borderColor = filledBackgroundViewBorderColour.cgColor
        messageText.isScrollEnabled = true
        let isRightOrientation = WMLocaleManager.isRightOrientationLocale()
        messageText.textContainerInset.left = isRightOrientation ? 45 : 10
        messageText.textContainerInset.right = isRightOrientation ? 10 : 45
        messageText.keyboardDismissMode = .none
        if #available(iOS 11.1, *) {
            messageText.showsVerticalScrollIndicator = true
            messageText.verticalScrollIndicatorInsets.right = sendButton.bounds.width + 15
        } else {
            messageText.showsVerticalScrollIndicator = false
        }
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height), height: 1)
        topBorder.backgroundColor = newMessageBorderColor.cgColor
        layer.addSublayer(topBorder)
        messageText.delegate = self

        translatesAutoresizingMaskIntoConstraints = false
        recountViewHeight()
    }

    @IBAction func sendMessage(_ sender: Any) {
        self.delegate?.sendMessage()
    }

    override func safeAreaInsetsDidChange() {
        invalidateContentSize()
    }
    
    @IBAction func sendFile(_ sender: UIButton) {
        self.delegate?.showSendFileMenu(sender)
    }

    func resignMessageViewFirstResponder() {
        messageText.resignFirstResponder()
    }
    
    func becomeMessageViewFirstResponder() {
        messageText.becomeFirstResponder()
    }
    
    func heightDelta() -> CGFloat {
        inputTextFieldConstraint.constant - WMNewMessageView.initialInputTextViewHeight
    }
    
    func getMessage() -> String {
        return self.messageText.text
    }
    
    func setMessageText(_ message: String) {
        self.messageText.text = message
        // Workaround to trigger textViewDidChange
        self.messageText.replace(
            self.messageText.textRange(
                from: self.messageText.beginningOfDocument,
                to: self.messageText.endOfDocument) ?? UITextRange(),
            withText: message
        )
        recountViewHeight()
    }
    
    func recountViewHeight() {
        let size = messageText.sizeThatFits(
            CGSize(width: messageText.frame.width,
                   height: CGFloat.greatestFiniteMagnitude)
        )

        let maxInputTextViewHeight = WMNewMessageView.maxInputTextViewHeight
        let newHeight = min(size.height, maxInputTextViewHeight)
        let oldHeight = inputTextFieldConstraint.constant
        let isScrollEnabled = size.height > maxInputTextViewHeight

        if isScrollEnabled != messageText.isScrollEnabled {
            messageText.isScrollEnabled = isScrollEnabled
        }

        guard newHeight != oldHeight else { return }
        animateViewHeightChanging(newHeight)
    }
    
    func insertText(_ text: String) {
        self.messageText.replace(self.messageText.selectedRange.toTextRange(textInput: self.messageText)!, withText: text)
    }

    // Config
    func set(textViewStrokeWidth: CGFloat) {
        messageText.layer.borderWidth = textViewStrokeWidth
    }

    func set(textViewCornerRadius: CGFloat) {
        messageText.layer.cornerRadius = textViewCornerRadius
    }

    func adjustConfig() {
        recountViewHeight()
        showHidePlaceholder(in: messageText)
        messagePlaceholder.textColor = placeholderTextColor
        messageText.textColor = textViewTextColor
    }
    
    private func setupTopBorderLayer() {
        let topBorder = CALayer()
        let width = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        topBorder.frame = CGRect(x: 0, y: 0, width: width, height: 1)
        topBorder.backgroundColor = newMessageBorderColor.cgColor
        layer.addSublayer(topBorder)
    }
    
    private func setupMessageTextView() {
        messageText.delegate = self
        messageText.layer.borderWidth = 1
        messageText.isScrollEnabled = true
        messageText.layer.cornerRadius = 17
        messageText.keyboardDismissMode = .none
        messageText.textContainerInset.left = 10
        messageText.textContainerInset.right = 10
        messageText.autoresizingMask = .flexibleHeight
        messageText.showsVerticalScrollIndicator = true
        if #available(iOS 11.1, *) {
            messageText.verticalScrollIndicatorInsets.right = sendButton.bounds.width + 10
        } else {
        }
    }
    
    private func animateViewHeightChanging(_ newHeight: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.inputTextFieldConstraint.constant = newHeight
            self.updateConstraintsIfNeeded()
        }
    }
    
    private func invalidateContentSize() {
        let delay: CGFloat = safeAreaInsets.bottom == 0 ? 0 : 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.invalidateIntrinsicContentSize()
            self.setMessageText(self.messageText.text)
        }
    }
}

extension WMNewMessageView: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showHidePlaceholder(in: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        recountViewHeight()
        showHidePlaceholder(in: textView)
        self.delegate?.inputTextChanged()
    }
    
    func showHidePlaceholder(in textView: UITextView) {
        let check = textView.hasText && !textView.text.isEmpty
        let checkButton = check && !textView.text.trimmingCharacters(in: .whitespaces).isEmpty
        messageText.layer.borderColor = (checkButton ? filledTextViewStrokeColor : emptyTextViewStrokeColor).cgColor
        messagePlaceholder.isHidden = check
        sendButton.isEnabled = checkButton
    }
}
