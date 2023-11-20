//
//  WMInfoMessageTableViewCell.swift
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

class WMInfoCell: WMMessageTableCell {
    @IBOutlet var messageTextView: UITextView!
    
    override func setMessage(message: Message) {
        super.setMessage(message: message)
        let textColor = config?.titleAttributes?[.foregroundColor] as? UIColor ?? infoMessageCellTextColor
        let textFont = config?.titleAttributes?[.font] as? UIFont ?? messageTextView.notNilFont()
        
        let _ = self.messageTextView.setTextWithReferences(
            message.getText(),
            textColor: textColor,
            textFont: textFont,
            alignment: .center,
            linkColor: config?.linkColor
        )
    }
    
    override func applyConfig() {

        guard let config = config else { return }

        if let backgroundColor = config.backgroundColor {
            messageTextView?.backgroundColor = backgroundColor
        }

        if let cornerRadius = config.cornerRadius {
            if let roundCorners = config.roundCorners {
                messageTextView?.roundCorners(roundCorners, radius: cornerRadius)
            } else {
                sharpCorner(view: messageView, visitor: message.isVisitorType(), radius: cornerRadius)
            }
        }

        if let timeColor = config.timeColor {
            time?.textColor = timeColor
        }
        
        if let strokeColor = config.strokeColor {
            messageTextView?.layer.borderColor = strokeColor.cgColor
        }
        
        if let strokeWidth = config.strokeWidth {
            messageTextView?.layer.borderWidth = strokeWidth
        }
    }
    
    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        return setup
    }
}
