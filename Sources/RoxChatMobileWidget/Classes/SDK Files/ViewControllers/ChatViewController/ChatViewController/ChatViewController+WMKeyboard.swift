//
//  ChatViewController+WMKeyboard.swift
//  RoxChat
//
//  
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
import RoxChatKeyboard

extension ChatViewController: WMKeyboardObservable { }

extension ChatViewController: WMKeyboardRepresentable {
    func keyboardWillShow(keyboardInfo: Notification.KeyboardInfo) {
        keyboardNotificationManager.adjustKeyboardNotification(keyboardInfo, kind: .keyboardWillShow)
    }
    
    func keyboardWillHide(keyboardInfo: Notification.KeyboardInfo) {
        keyboardNotificationManager.adjustKeyboardNotification(keyboardInfo, kind: .keyboardWillHide)
    }
    
    func keyboardDidShow(keyboardInfo: Notification.KeyboardInfo) {
        keyboardNotificationManager.adjustKeyboardNotification(keyboardInfo, kind: .keyboardDidShow)
    }
    
    func keyboardDidHide(keyboardInfo: Notification.KeyboardInfo) {
        keyboardNotificationManager.adjustKeyboardNotification(keyboardInfo, kind: .keyboardDidHide)
    }
}

extension ChatViewController: WMKeyboardManagerDelegate {
    var scrollViewModel: RoxChatKeyboard.WMScrollViewModel {
        WMScrollViewModel(
            toolbarViewHeight: inputAccessoryView?.bounds.height ?? 0,
            scrollViewContentOffset: chatTableView.contentOffset.y,
            scrollViewContentInset: chatTableView.contentInset.bottom
        )
    }
    
    var presented: Bool {
        return presentedViewController != nil
    }
    
    func set(contentOffset: CGFloat) {
        chatTableView.setContentOffset(CGPoint(x: .zero, y: contentOffset), animated: false)
    }
    
    func set(contentInset: CGFloat) {
        chatTableView.contentInset.bottom = contentInset
        chatTableView.verticalScrollIndicatorInsets.bottom = contentInset

        updateScrollButtonViewConstraints(with: contentInset)
        
    }
    
    func layoutIfNeeded() {
        view.layoutIfNeeded()
    }
    
    func updateScrollButtonViewConstraints(with inset: CGFloat) {
        let commonPadding: CGFloat = 22
        var bottomConstraint = inset + commonPadding
        bottomConstraint = max(bottomConstraint, 90)
        scrollButtonView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(bottomConstraint)
        }
        view.layoutIfNeeded()
    }
}
