//
//  String.swift
//  WMMessageTableViewCell.swift
//  Roxchat
//
//  Copyright © 2020 _roxchat_. All rights reserved.
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

class WMOperatorMessageCell: WMMessageTableCell {
    @IBOutlet var messageTextView: UITextView!
    
    override func setMessage(message: Message) {
        super.setMessage(message: message)
        setupTextWithRefference()
        messageTextView.removeInsets()
        messageTextView.delegate = self

        if !cellMessageWasInited {
            cellMessageWasInited = true
            for recognizer in messageTextView.gestureRecognizers ?? [] {
                if recognizer.isKind(of: UIPanGestureRecognizer.self) {
                    recognizer.isEnabled = false
                }
            }
            let longPressPopupGestureRecognizer = UILongPressGestureRecognizer(
                target: self,
                action: #selector(longPressAction)
            )
            longPressPopupGestureRecognizer.minimumPressDuration = 0.2
            longPressPopupGestureRecognizer.cancelsTouchesInView = false
            self.messageTextView.addGestureRecognizer(longPressPopupGestureRecognizer)
        }
    }

    override func resignTextViewFirstResponder() {
        messageTextView.resignFirstResponder()
    }
    
    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        if setup {
            sharpCorner(view: messageView, visitor: true)
        }
        return setup
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView.selectedTextRange?.isEmpty == false else { return }
        delegate?.cellChangeTextViewSelection(self)
    }
    
    private func setupTextWithRefference() {
        let textColor = config?.subtitleAttributes?[.foregroundColor] as? UIColor ?? operatorMessageCellTextColor
        let textFont = config?.subtitleAttributes?[.font] as? UIFont ?? messageTextView.notNilFont()
        
        let _ = self.messageTextView.setTextWithReferences(
            message.getText(),
            textColor: textColor,
            textFont: textFont,
            alignment: .left,
            linkColor: config?.linkColor)
    }
}
