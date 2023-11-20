//
//  ChatViewController+Listener.swift
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

extension ChatViewController: MessageListener {
    
    // MARK: - Methods
    
    func added(message newMessage: Message, after previousMessage: Message?) {
        chatMessagesQueue.async(flags: .barrier) {
            var inserted = false
            if !self.chatMessages.contains(where: { $0.getID() == newMessage.getID() }) {
                if let previousMessage = previousMessage {
                    for (index, message) in self.chatMessages.enumerated() {
                        if previousMessage.isEqual(to: message) {
                            self.chatMessages.insert(newMessage, at: index + 1)
                            inserted = true
                            break
                        }
                    }
                }
                
                if !inserted {
                    self.chatMessages.append(newMessage)
                }
            }
            
            let currentId = newMessage.getID()
            
            DispatchQueue.main.async {
                var snapshot = self.dataSource.snapshot()
                if snapshot.numberOfSections == 0 {
                    snapshot.appendSections([0])
                }
                
                if snapshot.itemIdentifiers.contains(currentId) {
                    snapshot.reloadItems([currentId])
                } else {
                    snapshot.appendItems([currentId], toSection: 0)
                }
                
                self.dataSource.apply(snapshot, animatingDifferences: false) {
                    guard newMessage.isVisitorType() || self.isLastCellVisible() else { return }
                    self.scrollToBottom(animated: true)
                }
                
                if let chatConfig = self.chatConfig as? WMChatViewControllerConfig,
                   chatConfig.showScrollButtonCounter != false {
                    self.messageCounter.set(lastMessageIndex: self.chatMessages.count - 1)
                }
            }
        }
    }
    
    func removed(message: Message) {
        chatMessagesQueue.async(flags: .barrier) {
            var snapshot = self.dataSource.snapshot()
            
            if let index = self.chatMessages.firstIndex(where: { $0.getID() == message.getID() }) {
                self.chatMessages.remove(at: index)
            }
            DispatchQueue.main.async {
                if snapshot.numberOfSections > 0 {
                    snapshot.deleteItems([message.getID()])
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
            }
        }
    }
    
    func removedAllMessages() {
        chatMessagesQueue.async(flags: .barrier) {
            
            self.chatMessages.removeAll()
            
            DispatchQueue.main.async {
                self.updateThreadListAndReloadTable()
            }
        }
    }
    
    func changed(message oldVersion: Message, to newVersion: Message) {
        chatMessagesQueue.async(flags: .barrier) {
            let id = oldVersion.getID()
            
            guard let index = self.chatMessages.firstIndex(where: { $0.getID() == id }) else { return }
            
            self.chatMessages[index] = newVersion
            
            DispatchQueue.main.async {
                var snapshot = self.dataSource.snapshot()
                
                if snapshot.numberOfSections > 0 {
                    if snapshot.itemIdentifiers.contains(id) {
                        snapshot.reloadItems([id])
                    } else {
                        snapshot.appendItems([newVersion.getID()], toSection: 0)
                    }
                    
                    self.dataSource.apply(snapshot, animatingDifferences: false) {
                        guard let delayedScrollLink = self.delayedScrollLink,
                              delayedScrollLink == id else {
                            guard self.isLastCellVisible() else { return }
                            self.scrollToBottom(animated: true)
                            return
                        }
                        self.scrollToDelayedLink(delayedScrollLink, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - ROXCHAT: HelloMessageListener
extension ChatViewController: HelloMessageListener {
    func helloMessage(message: String) {
        print("Received Hello message: \"\(message)\"")
    }
}

extension ChatViewController: OperatorTypingListener {
    func onOperatorTypingStateChanged(isTyping: Bool) {
        guard RoxchatServiceController.currentSession.getCurrentOperator() != nil else { return }
        updateOperatorTypingStatus(typing: isTyping)
    }
}

// MARK: - ROXCHAT: CurrentOperatorChangeListener
extension ChatViewController: CurrentOperatorChangeListener {
    func changed(operator previousOperator: Operator?, to newOperator: Operator?) {
        updateOperatorInfo(operator: newOperator, state: RoxchatServiceController.currentSession.sessionState())
    }
}

// MARK: - ROXCHAT: ChatStateLisneter
extension ChatViewController: ChatStateListener {
    func changed(state previousState: ChatState, to newState: ChatState) {
        let currentSessionState = RoxchatServiceController.currentSession.sessionState()
        if (newState == .closedByVisitor || newState == .closedByOperator) && (currentSessionState == .chatting || currentSessionState == .queue || currentSessionState == .chattingWithRobot) {
            
            if let currentId = currentOperatorId(), alreadyRatedOperators[currentId] != true && roxchatServerSideSettingsManager.isRateOperatorEnabled() {
                showRateOperatorDialog(operatorId: currentOperatorId())
            }
        }
        
        updateOperatorInfo(operator: RoxchatServiceController.currentSession.getCurrentOperator(), state: newState)
    }
}

extension ChatViewController: VisitSessionStateListener {
    func changed(state previousState: VisitSessionState, to newState: VisitSessionState) {
        if newState == .firstQuestion {
            checkAgreement()
        }
    }
}
