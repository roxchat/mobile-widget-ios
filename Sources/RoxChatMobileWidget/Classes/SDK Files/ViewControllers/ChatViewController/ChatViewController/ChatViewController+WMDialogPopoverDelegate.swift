//
//  ChatViewController+.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2022 Roxchat. All rights reserved.
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
import RoxchatClientLibrary

extension ChatViewController: WMDialogPopoverDelegate {
    func addQuoteReplyBar() {
        if self.selectedMessage?.isFile() ?? false && self.selectedMessage?.getData()?.getAttachment()?.getFileInfo().getImageInfo() != nil {
            self.toolbarView.quoteView.quoteImageView.isUserInteractionEnabled = true
            self.toolbarView.quoteView.quoteImageView.gestureRecognizers = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.toolbarView.addQuoteBarForMessage(self.selectedMessage, delegate: self)
            self.toolbarView.messageView.messageText.becomeFirstResponder()
        }
    }
    
    func hideQuoteView() {
        self.toolbarView.removeQuoteEditBar()
    }
    
    func addQuoteEditBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.toolbarView.addQuoteEditBarForMessage(self.selectedMessage, delegate: self)
            self.toolbarView.messageView.messageText.becomeFirstResponder()
        }
    }
    
    func likeMessage() {
        self.reactMessage(reaction: ReactionString.like)
    }
    
    func dislikeMessage() {
        self.reactMessage(reaction: ReactionString.dislike)
    }
    
    func removeQuoteEditBar() {
        self.toolbarView.removeQuoteEditBar()
    }
}
